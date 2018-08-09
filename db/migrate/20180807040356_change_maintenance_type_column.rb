class ChangeMaintenanceTypeColumn < ActiveRecord::Migration[5.2]
  def up
    remove_column :maintenances, :maintenance_type
    add_column :maintenances, :maintenance_type_id, :integer
  end

  def down
    add_column :maintenances, :maintenance_type, :integer
    remove_column :maintenances, :maintenance_type_id
  end
end
