class AddExtraFieldsToDocuments < ActiveRecord::Migration[6.0]
  def change
    add_column :documents, :driver_advance, :decimal, precision: 11
    add_column :documents, :company_advance, :decimal, precision: 11
    add_column :documents, :advance_responsible, :integer
    add_column :documents, :balance_in_favor, :decimal, precision: 11
    add_column :documents, :balance_in_favor_of, :integer, default: 0
    add_column :documents, :pending_company_amount, :decimal, precision: 11
    add_column :documents, :pending_company_amount_paid, :decimal, precision: 11
    add_column :documents, :paid_date, :date
    add_column :documents, :retentions, :decimal, precision: 11
  end
end
