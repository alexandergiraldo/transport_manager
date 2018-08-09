class AddRegisterIdToMaintenances < ActiveRecord::Migration[5.2]
  def change
    add_column :maintenances, :register_id, :integer
  end
end
