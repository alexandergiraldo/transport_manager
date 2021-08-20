class AddVehicleTypeToVehicles < ActiveRecord::Migration[5.2]
  def change
    add_column :vehicles, :vehicle_type, :integer, default: 0
  end
end
