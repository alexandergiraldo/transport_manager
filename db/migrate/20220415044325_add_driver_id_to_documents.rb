class AddDriverIdToDocuments < ActiveRecord::Migration[6.0]
  def change
    add_reference :documents, :driver, index: true
  end
end
