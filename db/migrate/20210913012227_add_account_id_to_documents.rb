class AddAccountIdToDocuments < ActiveRecord::Migration[5.2]
  def up
    add_column :documents, :account_id, :integer
    add_index :documents, :account_id
  end

  def down
    remove_index :documents, :account_id
    remove_column :documents, :account_id
  end
end
