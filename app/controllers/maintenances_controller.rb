class MaintenancesController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :init_date_params, only: [:index]

  def index
    @pagy, @maintenances = pagy(policy_scope(Maintenance).where(vehicle_id: current_vehicle.id).search(params).by_date, items: 31)
  end

  def new
    @maintenance = Maintenance.new
  end

  def create
    @maintenance_service = ::Maintenances::MultipleMaintenancesService.new({vehicle: {maintenances_attributes: {"0" => maintenance_params}}}, current_user, current_vehicle)

    if @maintenance_service.process
      redirect_to maintenances_path, flash: {success: "Registro de mantenimiento creado exitosamente"}
    else
      self.index
      flash[:error] = "Ha ocurrido un error"
      render :index
    end
  end

  def create_multiple
    @maintenance_service = ::Maintenances::MultipleMaintenancesService.new(params.to_unsafe_h, current_user, current_vehicle)

    if @maintenance_service.process
      redirect_to maintenances_path, flash: {success: "Registros de mantenimiento creados exitosamente"}
    else
      flash[:error] = "Ha ocurrido un error"
      render :new
    end
  end

  def update
    @maintenance = Maintenance.find(params[:id])
    authorize @maintenance, :update?

    if @maintenance.update(vehicle_params)
      redirect_to maintenances_path, flash: {success: "Registro de mantenimiento actualizado exitosamente"}
    else
      render :new
    end
  end

  def destroy
    @maintenance = Maintenance.find(params[:id])
    authorize @maintenance, :update?

    if @maintenance.destroy
      redirect_to maintenances_path, flash: {alert: "Registro de mantenimiento eliminado exitosamente"}
    else
      render :new
    end
  end

  protected

  def maintenance_params
    params.require(:maintenance).permit(:description, :category, :event_date, :value, :vehicle_id, :registrable)
  end
end