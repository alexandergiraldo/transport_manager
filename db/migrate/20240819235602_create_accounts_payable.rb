class CreateAccountsPayable < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts_payables do |t|
      t.string :name
      t.string :external_invoice
      t.integer :total_amount
      t.integer :amount_paid
      t.integer :balance_due
      t.integer :recurring_type
      t.date :payment_date
      t.integer :payment_day
      t.string :notes
      t.references :account, null: false, foreign_key: true
      t.references :vehicle, null: false, foreign_key: true
      t.references :vendor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
