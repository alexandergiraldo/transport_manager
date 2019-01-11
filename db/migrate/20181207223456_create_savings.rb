class CreateSavings < ActiveRecord::Migration[5.2]
  def change
    create_table :savings do |t|
      t.integer :driver_id
      t.date :event_date
      t.integer :amount
      t.references :user

      t.timestamps
    end
    add_index :savings, :driver_id
  end
end
