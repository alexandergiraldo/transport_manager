class AddUserIdToRegistersAndMaintenances < ActiveRecord::Migration[5.2]
  def change
    add_column :maintenances, :user_id, :integer
    add_column :registers, :user_id, :integer
  end
end
