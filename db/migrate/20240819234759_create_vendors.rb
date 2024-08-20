class CreateVendors < ActiveRecord::Migration[6.1]
  def change
    create_table :vendors do |t|
      t.string :name
      t.string :phone_number
      t.string :email
      t.string :contact_person
      t.string :tax_id
      t.integer :account_number
      t.string :account_type
      t.string :bank_name
      t.string :notes
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
