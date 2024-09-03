module Payments
  class PaymentDestroy
    attr_reader :payment

    def initialize(id)
      @payment = Payment.find(id)
    end

    def call
      Payment.transaction do
        if payment.destroy
          accounts_payable = payment.accounts_payable
          accounts_payable.add_payment(-payment.amount)
        end
      end

      return true if payment.destroyed?
      return false
    rescue ActiveRecord::RecordInvalid
      return false
    end
  end
end