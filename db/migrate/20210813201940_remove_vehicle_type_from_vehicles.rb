class RemoveVehicleTypeFromVehicles < ActiveRecord::Migration[5.2]
  def change
    remove_column :vehicles, :vehicle_type
  end
end
