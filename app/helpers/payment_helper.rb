module PaymentHelper
  def options_for_payment_methods(payment)
    options_for_select(
      Payment.payment_methods.map { |key, value|
        [I18n.t("payment.payment_methods.#{key}"), Payment.payment_methods.key(value)]
      },
      payment.payment_method
    )
  end
end
