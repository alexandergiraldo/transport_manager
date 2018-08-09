class CreateDrivers < ActiveRecord::Migration[5.2]
  def change
    create_table :drivers do |t|
      t.string :name
      t.string :identification_id
      t.string :insurance
      t.string :pension_company
      t.text :notes
      t.string :address
      t.string :phone_number
      t.string :mobile_number
      t.string :email
      t.date :birthday

      t.timestamps
    end
  end
end
