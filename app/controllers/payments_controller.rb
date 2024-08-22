class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @payments = policy_scope(Payment).where(accounts_payable_id: params[:accounts_payable_id])
  end

  def show
    @payment = Payment.find(params[:id])
    authorize @payment, :show?
  end

  def new
    @payment = Payment.new(accounts_payable_id: params[:accounts_payable_id])
    authorize @payment, :create?

    respond_to do |format|
      format.js {
          render  :action => "new.js.erb",
                  :layout => false
      }
    end
  end

  def create
    @payment_creator = ::Payments::PaymentCreator.new(payment_params, current_account)
    authorize @payment_creator.payment, :create?

    if @payment_creator.call
      redirect_to accounts_payables_path, success: 'Pago abonado exitosamente'
    else
      fash.now[:error] = @payment_creator.payment.errors.full_messages.join("\n")
      @payment = @payment_creator.payment
      render :new
    end
  end

  private

  def payment_params
    p_params = params.require(:payment).permit(:payment_date, :amount, :payer_details, :payment_method, :notes, :accounts_payable_id)
    p_params[:accounts_payable_id] = params[:accounts_payable_id]
    p_params[:amount] = Register.sanitize_amount(p_params[:amount])
    p_params
  end
end