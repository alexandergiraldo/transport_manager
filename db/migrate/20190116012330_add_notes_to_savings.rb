class AddNotesToSavings < ActiveRecord::Migration[5.2]
  def change
    add_column :savings, :notes, :text
  end
end
