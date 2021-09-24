class CreatePreloadRegisters < ActiveRecord::Migration[5.2]
  def change
    create_table :register_sketches do |t|
      t.string "name"
      t.integer "account_id"

      t.timestamps
    end

    create_table :preload_registers do |t|
      t.text "description"
      t.integer "register_type"
      t.integer "account_id"
      t.decimal "value", precision: 11, default: "0"
      t.string "notes"
      t.integer :register_sketch_id

      t.timestamps
    end

    add_index :preload_registers, :account_id
    add_index :register_sketches, :account_id
    add_index :preload_registers, :register_sketch_id
  end
end
