class RegistersController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :init_date_params, only: [:index]

  def index
    @pagy, @registers = pagy(policy_scope(Register).where(vehicle_id: current_vehicle.id).search(params).by_date, items: 60)
  end

  def new
    @maintenance = Maintenance.new
  end

  def create
    @register_service = ::Registers::MultipleRegistersService.new({vehicle: {registers_attributes: {"0" => register_params}}}, current_user, current_vehicle)

    if @register_service.process
      redirect_to request.referer, flash: {success: "Registro creado exitosamente"}
    else
      self.index
      flash[:error] = "Ha ocurrido un error"
      render :index
    end
  end

  def create_multiple
    @register_service = ::Registers::MultipleRegistersService.new(params.to_unsafe_h, current_user, current_vehicle)

    if @register_service.process
      redirect_to registers_path, flash: {success: "Registros creados exitosamente"}
    else
      flash[:error] = "Ha ocurrido un error"
      render :new
    end
  end

  def update
    @register = Register.find(params[:id])
    authorize @register, :update?

    if @register.update(vehicle_params)
      redirect_to registers_path, flash: {success: "Registro actualizado exitosamente"}
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
    params.require(:register).permit(:description, :category, :register_type, :notes, :event_date, :value, :vehicle_id, :maintainable)
  end
end