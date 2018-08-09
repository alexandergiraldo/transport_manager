class CreateMaintenanceTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :maintenance_types do |t|
      t.string :name
      t.references :account

      t.timestamps
    end

    add_index :maintenance_types, [:account_id, :name]
  end
end
