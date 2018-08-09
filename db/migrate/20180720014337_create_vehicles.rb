class CreateVehicles < ActiveRecord::Migration[5.2]
  def change
    create_table :vehicles do |t|
      t.string :license_plate
      t.string :side_number
      t.string :model_date
      t.string :vehicle_type
      t.string :status
      t.references :account

      t.timestamps
    end
  end
end
