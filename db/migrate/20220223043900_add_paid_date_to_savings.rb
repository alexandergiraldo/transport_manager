class AddPaidDateToSavings < ActiveRecord::Migration[6.0]
  def change
    add_column :savings, :paid_date, :datetime, null: true
  end
end
