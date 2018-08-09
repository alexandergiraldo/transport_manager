class RenameRecordTypeToRegisterType < ActiveRecord::Migration[5.2]
  def change
    rename_column :registers, :record_type, :register_type
  end
end
