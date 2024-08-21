class AccountsPayablesController < ApplicationController
  before_action :authenticate_user!

  def index
    @accounts_payables = policy_scope(AccountsPayable).where(vehicle_id: current_vehicle.id).includes(:vendor).search(params)
  end

  def show
    @accounts_payable = AccountsPayable.find(params[:id])
    authorize @accounts_payable, :show?
  end

  def new
    @accounts_payable = AccountsPayable.new
    authorize @accounts_payable, :create?
  end

  def create
    @accounts_payable = AccountsPayable.new(accounts_payable_params)
    authorize @accounts_payable, :create?
    @accounts_payable.account_id = current_account_id
    @accounts_payable.vehicle_id = current_vehicle.id

    if @accounts_payable.save
      redirect_to accounts_payables_path, flash: {success: "Cuenta por Cobrar creada exitosamente"}
    else
      flash.now[:error] = @accounts_payable.errors.full_messages.join("\n")
      render :new
    end
  end

  def edit
    @accounts_payable = AccountsPayable.find(params[:id])
    authorize @accounts_payable, :update?
  end

  def update
    @accounts_payable = AccountsPayable.find(params[:id])
    authorize @accounts_payable, :update?

    if @accounts_payable.update(accounts_payable_params)
      redirect_to accounts_payables_path, flash: {success: "Cuenta de Cobro actualizada exitosamente"}
    else
      flash.now[:error] = @accounts_payable.errors.full_messages.join("\n")
      render :edit
    end
  end

  def destroy
    @accounts_payable = AccountsPayable.find(params[:id])
    authorize @accounts_payable, :destroy?

    if @accounts_payable.destroy
      redirect_to accounts_payables_path, flash: {alert: "Cuenta de Cobro eliminada exitosamente"}
    else
      redirect_to accounts_payables_path, flash: {alert: "Error eliminando Cuenta de Cobro"}
    end
  end

  def mark_as_paid
    @accounts_payable = AccountsPayable.find(params[:id])
    authorize @accounts_payable, :update?

    if @accounts_payable.mark_as_paid
      redirect_to accounts_payables_path, flash: { success: "Cuenta de Cobro marcada como pagada exitosamente" }
    else
      redirect_to accounts_payables_path, flash: { alert: "Error marcando Cuenta de Cobro como pagada" }
    end
  end

  protected

  def accounts_payable_params
    a_params = params.require(:accounts_payable).permit(:vendor_id, :total_amount, :name, :notes, :payment_date, :external_invoice, :recurring_type, :payment_day, :vehicle_id)
    a_params[:total_amount] = Register.sanitize_amount(a_params[:total_amount])
    a_params
  end
end
