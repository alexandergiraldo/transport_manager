class RenameRecordsToRegisters < ActiveRecord::Migration[5.2]
  def change
    rename_table :records, :registers
  end
end
