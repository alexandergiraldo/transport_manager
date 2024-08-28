class ChangeColumnTypeForAccountType < ActiveRecord::Migration[6.1]
  def up
    remove_column :vendors, :account_type
    add_column :vendors, :account_type, :integer
  end

  def down
    remove_column :vendors, :account_type
    add_column :vendors, :account_type, :string
  end
end
