class CreateDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :documents do |t|
      t.string :title
      t.text :description
      t.date :event_date
      t.references :user
      t.integer :vehicle_id, index: true

      t.timestamps
    end
  end
end
