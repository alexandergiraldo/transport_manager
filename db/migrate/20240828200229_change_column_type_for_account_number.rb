class ChangeColumnTypeForAccountNumber < ActiveRecord::Migration[6.1]
  def change
    change_column :vendors, :account_number, :bigint
  end
end
