class AddStartDateToAccountsPayables < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts_payables, :start_date, :date, null: false
  end
end
