class AddLocationFieldsToDocuments < ActiveRecord::Migration[6.1]
  def change
    add_column :documents, :from_latitude, :decimal, precision: 10, scale: 6
    add_column :documents, :from_longitude, :decimal, precision: 10, scale: 6
    add_column :documents, :to_latitude, :decimal, precision: 10, scale: 6
    add_column :documents, :to_longitude, :decimal, precision: 10, scale: 6
  end
end
