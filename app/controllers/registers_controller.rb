class RegistersController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :init_date_params, only: [:index]

  def index
    @documents = policy_scope(Document).where(vehicle_id: current_vehicle.id).search(params).includes(registers: [:vehicle]).by_date
    @pagy, @registers = pagy(policy_scope(Register).where(vehicle_id: current_vehicle.id, document_id: nil).search(params).by_date, items: 60)
  end

  def print
    @registers = policy_scope(Register).where(vehicle_id: current_vehicle.id).search(params).by_date
  end

  def new
    @document = Document.find_by(id: params[:document_id])
    @register = Register.new
  end

  def create
    @register_service = ::Registers::MultipleRegistersService.new({vehicle: {registers_attributes: {"0" => register_params}}}, current_user, current_vehicle, current_account)

    if @register_service.process
      redirect_to request.referer, flash: {success: "Registro creado exitosamente"}
    else
      flash.now[:error] = @register_service.errors.join("<br/>")
      @document = Document.find_by(id: params[:document_id])
      render :new
    end
  end

  def create_multiple
    @register_service = ::Registers::MultipleRegistersService.new(params.to_unsafe_h, current_user, current_vehicle, current_account)

    if @register_service.process
      redirect_to registers_path(open_document: params[:document_id]), flash: {success: "Registros creados exitosamente"}
    else
      flash.now[:error] = @register_service.errors.join("<br/>")
      @document = Document.find_by(id: params[:document_id])
      render :new
    end
  end

  def edit
    @register = Register.find(params[:id])
    params[:q] = { event_date_gteq: Time.now.beginning_of_month, event_date_lteq: Time.now.end_of_month }
    @documents = policy_scope(Document).where(vehicle_id: current_vehicle.id).search(params).by_date

    respond_to do |format|
      format.js {
          render  :action => "edit.js.erb",
                  :layout => false
      }
    end
  end

  def update
    @register = Register.find(params[:id])
    authorize @register, :update?

    if @register.update(register_params)
      redirect_to registers_path(open_document: @register.document_id), flash: {success: "Registro actualizado exitosamente"}
    else
      render :new
    end
  end

  def destroy
    @register = Register.find(params[:id])
    authorize @register, :update?

    if @register.destroy
      redirect_to request.referer, flash: {alert: "Registro eliminado exitosamente"}
    else
      render :new
    end
  end

  protected

  def register_params
    params.require(:register).permit(:description, :category, :register_type, :notes, :event_date, :value, :vehicle_id, :maintainable, :document_id)
  end
end