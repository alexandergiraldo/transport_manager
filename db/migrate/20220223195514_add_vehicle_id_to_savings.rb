class AddVehicleIdToSavings < ActiveRecord::Migration[6.0]
  def change
    add_reference :savings, :vehicle, index: true
  end
end
