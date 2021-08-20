class AddCompanyAndLoadTypeToDocuments < ActiveRecord::Migration[5.2]
  def change
    add_column :documents, :company, :string
    add_column :documents, :load_type, :string
  end
end
