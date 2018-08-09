class AddMissingFields < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :vehicle_ids, :text, array: true, default: []
    add_column :drivers, :account_id, :integer
    add_index :drivers, :account_id
  end
end
