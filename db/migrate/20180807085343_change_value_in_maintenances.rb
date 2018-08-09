class ChangeValueInMaintenances < ActiveRecord::Migration[5.2]
  def change
    change_column(:maintenances, :value, :decimal, precision: 11, default: 0.0)
  end
end
