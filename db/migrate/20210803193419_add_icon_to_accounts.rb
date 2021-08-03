class AddIconToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :cars_icon, :integer, default: 0
  end
end
