class CreateAccountUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :account_users do |t|
      t.references :user
      t.references :account

      t.timestamps
    end
  end
end
