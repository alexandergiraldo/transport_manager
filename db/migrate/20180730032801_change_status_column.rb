class ChangeStatusColumn < ActiveRecord::Migration[5.2]
  def change
    change_column(:vehicles, :status, :integer, default: 0, using: 'status::integer')
  end
end
