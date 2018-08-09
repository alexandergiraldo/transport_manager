class CreateRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :records do |t|
      t.text :description
      t.date :record_date
      t.integer :record_type
      t.integer :vehicle_id, index: true
      t.decimal :value, precision: 1, default: 0.0

      t.timestamps
    end

    add_index :records, [:vehicle_id, :record_date]
    add_index :records, :record_date

  end
end
