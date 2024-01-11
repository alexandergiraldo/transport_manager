class VehiclesController < ApplicationController
  before_action :authenticate_user!

  def index
    @vehicles = policy_scope(Vehicle).by_date
    @vehicles = params[:status] == 'active' ? @vehicles.active : @vehicles
  end

  def new
    @vehicle = Vehicle.new
  end

  def create
    @vehicle = Vehicle.new(vehicle_params)
    @vehicle.account_id = current_account_id
    authorize @vehicle, :create?

    if @vehicle.save
      redirect_to vehicles_path(status: 'active'), flash: {success: "Vehículo creado exitosamente"}
    else
      render :new
    end
  end

  def edit
    @vehicle = Vehicle.find(params[:id])
    authorize @vehicle, :update?
  end

  def update
    @vehicle = Vehicle.find(params[:id])
    authorize @vehicle, :update?

    if @vehicle.update(vehicle_params)
      redirect_to vehicles_path(status: 'active'), flash: {success: "Vehículo actualizado exitosamente"}
    else
      render :new
    end
  end

  def destroy
    @vehicle = Vehicle.find(params[:id])
    authorize @vehicle, :update?

    if @vehicle.archived!
      redirect_to vehicles_path(status: 'active'), flash: {alert: "Vehículo archivado exitosamente"}
    else
      render :new
    end
  end

  protected

  def vehicle_params
    params.require(:vehicle).permit(:license_plate, :side_number, :model_date, :vehicle_type, :status)
  end
end