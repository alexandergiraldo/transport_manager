class AddNotesToRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :records, :notes, :string
  end
end
