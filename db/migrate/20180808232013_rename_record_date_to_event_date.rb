class RenameRecordDateToEventDate < ActiveRecord::Migration[5.2]
  def change
    rename_column :registers, :record_date, :event_date
  end
end
