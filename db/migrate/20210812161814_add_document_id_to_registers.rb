class AddDocumentIdToRegisters < ActiveRecord::Migration[5.2]
  def up
    add_column :registers, :document_id, :integer
    add_index :registers, :document_id
  end

  def down
    remove_index :registers, :document_id
    remove_column :registers, :document_id
  end
end
