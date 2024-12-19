class SavingsController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :init_date_params, :filter_driver, only: [:index]
  before_action :filter_driver, only: [:index2]

  content_security_policy only: [:index, :index2, :new, :edit, :update] do |policy|
    policy.style_src :self, :unsafe_inline, 'https://cdn.jsdelivr.net', 'https://cdnjs.cloudflare.com'
  end

  def index
    result = policy_scope(Saving)
    result = result.search(params).by_date
    @pagy, @savings = pagy(result, items: 60)
  end

  def index2
    result = policy_scope(Saving)
    result = result.search(params).includes(:vehicle).by_date_desc
    @pagy, @savings = pagy(result, items: 60)

    @total = policy_scope(Saving).search(params).sum(:amount)
    @total_saved = policy_scope(Saving).search({
      q: {
        status_eq: Saving.statuses[:saved],
        driver_id_eq: params[:q][:driver_id_eq]
      }
    }).sum(:amount)
    @total_paid = policy_scope(Saving).search({
      q: {
        status_eq: Saving.statuses[:paid],
        driver_id_eq: params[:q][:driver_id_eq]
      }
    }).sum(:amount)
  end

  def new
    @saving = Saving.new(driver_id: params[:driver_id])
  end

  def create
    @saving_service = ::Savings::MultipleSavingsService.new(params.to_unsafe_h, current_user)

    if @saving_service.process
      redirect_to view_context.saving_main_path(q: {driver_id_eq: params[:driver_id]}), flash: {success: "Ahorros creados exitosamente"}
    else
      flash[:error] = "Ha ocurrido un error: #{@saving_service.errors.join("<br/>")}"
      render :new
    end
  end

  def edit
    @saving = Saving.find(params[:id])
    authorize @saving, :update?

    respond_to do |format|
      format.js {
          render  :action => "edit",
                  :layout => false
      }
    end
  end

  def update
    @saving = Saving.find(params[:id])
    authorize @saving, :update?

    if @saving.update(saving_params)
      redirect_to view_context.saving_main_path(q: {driver_id_eq: @saving.driver_id}), flash: {success: "Ahorros actualizado exitosamente"}
    else
      redirect_to view_context.saving_main_path(q: {driver_id_eq: @saving.driver_id}), flash: {success: "Ha ocurrido un error"}
    end
  end

  def destroy
    @saving = Saving.find(params[:id])
    authorize @saving, :update?

    if @saving.destroy
      redirect_to request.referer, flash: {alert: "Ahorro eliminado exitosamente"}
    else
      render :new
    end
  end

  def mark_as_paid
    @saving = Saving.find(params[:id])
    authorize @saving, :update?

    if @saving.paid!
      @saving.reload
      @saving.update!(paid_date: Time.zone.now)
    end

    redirect_to request.referer, flash: {success: "Pago aplicado exitosamente"}
  end

  protected

  def saving_params
    s_params = params.require(:saving).permit(:event_date, :amount, :notes, :paid_date, :vehicle_id)
    s_params[:amount] = Saving.sanitize_amount(s_params[:amount])
    s_params
  end

  def filter_driver
    if params[:q].blank?
      params[:q] = {
        driver_id_eq: view_context.drivers_list.first.try(:[],1)
      }
    else
      params[:q][:driver_id_eq] = view_context.drivers_list.first.try(:[],1) unless params[:q][:driver_id_eq].present?
    end
  end

end
