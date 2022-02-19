class DriversController < ApplicationController
  before_action :authenticate_user!

  def index
    @drivers = policy_scope(Driver).by_date
  end

  def new
    @driver = Driver.new
  end

  def show
    @driver = Driver.find(params[:id])
  end

  def create
    @driver = Driver.new(driver_params)
    @driver.account_id = current_account_id
    authorize @driver, :create?

    if @driver.save
      redirect_to drivers_path, flash: {success: "Conductor creado exitosamente"}
    else
      render :new
    end
  end

  def edit
    @driver = Driver.find(params[:id])
    authorize @driver, :update?
  end

  def update
    @driver = Driver.find(params[:id])
    authorize @driver, :update?

    if @driver.update(driver_params)
      redirect_to drivers_path, flash: {success: "Conductor actualizado exitosamente"}
    else
      puts @driver.errors.inspect
      render :new, flash: {alert: "Error actualizando"}
    end
  end

  def destroy
    @driver = Driver.find(params[:id])
    authorize @driver, :update?

    if @driver.destroy
      redirect_to drivers_path, flash: {alert: "Conductor archivado exitosamente"}
    else
      render :new
    end
  end

  protected

  def driver_params
    params.require(:driver).permit(:name, :identification_id, :address, :mobile_number, :phone_number, :insurance, :pension_company, :email, :birthday, :notes)
  end
end