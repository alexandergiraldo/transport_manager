class AddRegisterIdToPayments < ActiveRecord::Migration[6.1]
  def change
    add_reference :payments, :register, null: true, foreign_key: true
  end
end
