class AddDefaultValueToPaymentMethod < ActiveRecord::Migration[6.1]
  def change
    change_column_default :payments, :payment_method, from: nil, to: 0
  end
end
