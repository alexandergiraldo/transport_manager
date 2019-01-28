class SavingsController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :init_date_params, :filter_driver, only: [:index]

  def index
    result = policy_scope(Saving)
    result = result.search(params).by_date
    @pagy, @savings = pagy(result, items: 60)
  end

  def new
    @saving = Saving.new(driver_id: params[:driver_id])
  end

  def create
    @saving_service = ::Savings::MultipleSavingsService.new(params.to_unsafe_h, current_user)

    if @saving_service.process
      redirect_to savings_path(q: {driver_id_eq: params[:driver_id]}), flash: {success: "Ahorros creados exitosamente"}
    else
      flash[:error] = "Ha ocurrido un error: #{@saving_service.errors.join("<br/>")}"
      render :new
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

  protected

  def filter_driver
    params[:q][:driver_id_eq] = view_context.drivers_list.first.try(:[],1) unless params[:q][:driver_id_eq].present?
  end

end
