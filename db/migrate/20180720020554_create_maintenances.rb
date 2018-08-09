class CreateMaintenances < ActiveRecord::Migration[5.2]
  def change
    create_table :maintenances do |t|
      t.text :description
      t.integer :maintenance_type
      t.date :event_date
      t.decimal :value, precision: 1, default: 0.0
      t.references :vehicle

      t.timestamps
    end
  end
end
