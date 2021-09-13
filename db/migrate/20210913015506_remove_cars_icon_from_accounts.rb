class RemoveCarsIconFromAccounts < ActiveRecord::Migration[5.2]
  def change
    remove_column :accounts, :cars_icon
  end
end
