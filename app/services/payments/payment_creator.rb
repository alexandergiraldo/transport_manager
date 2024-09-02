module Payments
  class PaymentCreator
    attr_reader :payment

    def initialize(params, account)
      @params = params
      @account = account
      @payment = Payment.new(params)
    end

    def call
      payment.account_id = @account.id
      Payment.transaction do
        if payment.save
          accounts_payable = payment.accounts_payable
          accounts_payable.add_payment(payment.amount)
        end
      end

      return true if payment.persisted?
      return false
    rescue ActiveRecord::RecordInvalid
      return false
    end
  end
end
