class CreateAccountsPayable < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts_payables do |t|
      t.string :name
      t.string :external_invoice
      t.integer :total_amount
      t.integer :amount_paid, default: 0
      t.integer :recurring_type, default: 0
      t.integer :status, default: 0
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
