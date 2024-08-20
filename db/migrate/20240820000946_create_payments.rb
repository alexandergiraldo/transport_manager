class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|
      t.date :payment_date
      t.integer :amount
      t.integer :payment_method
      t.references :accounts_payable, null: false, foreign_key: true
      t.string :payer_details
      t.string :notes

      t.timestamps
    end
  end
end
