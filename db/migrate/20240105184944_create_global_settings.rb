class CreateGlobalSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :global_settings do |t|
      t.integer :day_fee
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end
