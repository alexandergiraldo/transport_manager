class AddStatusToSavings < ActiveRecord::Migration[6.0]
  def change
    add_column :savings, :status, :integer, default: 0
  end
end
