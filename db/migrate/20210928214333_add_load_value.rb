class AddLoadValue < ActiveRecord::Migration[5.2]
  def change
    add_column :documents, :load_value, :decimal, precision: 11
    add_column :documents, :load_size, :string
  end
end
