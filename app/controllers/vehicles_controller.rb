class VehiclesController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_user!

  def index
    @vehicles = policy_scope(Vehicle).by_model_date.includes(:image_attachment)
    @vehicles = params[:status] == 'active' ? @vehicles.active : @vehicles
    @pagy, @vehicles = pagy(@vehicles, items: 20)
  end

  def show
    @vehicle = Vehicle.find(params[:id])
    authorize @vehicle, :show?

    reports = Report.new(@vehicle.id)
    @vehicle_utilities_by_year = reports.vehicle_utilities_by_year(Time.now.year)
    @total_vehicle_utilities = reports.total_vehicle_utilities
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
      @vehicle.image.purge if params[:remove_image] == '1'
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
    params.require(:vehicle).permit(:license_plate, :side_number, :model_date, :vehicle_type, :status, :image)
  end
end