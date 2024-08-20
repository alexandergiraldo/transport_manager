class VendorsController < ApplicationController
  before_action :authenticate_user!
  def index
    @vendors = policy_scope(Vendor).by_name
  end

  def new
    @vendor = Vendor.new
    authorize @vendor, :create?
  end

  def create
    @vendor = Vendor.new(vendor_params)
    authorize @vendor, :create?
    @vendor.account_id = current_account_id

    if @vendor.save
      redirect_to vendors_path, flash: {success: "Proveedor creado exitosamente"}
    else
      render :new
    end
  end

  def edit
    @vendor = Vendor.find(params[:id])
    authorize @vendor, :update?
  end

  def update
    @vendor = Vendor.find(params[:id])
    authorize @vendor, :update?

    if @vendor.update(vendor_params)
      redirect_to vendors_path, flash: {success: "Proveedor actualizado exitosamente"}
    else
      render :edit
    end
  end

  def destroy
    @vendor = Vendor.find(params[:id])
    authorize @vendor, :destroy?

    if @vendor.destroy
      redirect_to vendors_path, flash: {alert: "Proveedor eliminado exitosamente"}
    else
      redirect_to vendors_path, flash: {alert: "Error eliminando proveedor"}
    end
  end

  protected

  def vendor_params
    params.require(:vendor).permit(:name, :email, :phone_number, :contact_person, :tax_id, :account_number, :account_type, :bank_name, :notes)
  end
end
