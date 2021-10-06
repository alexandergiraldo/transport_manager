class AddLoadManifest < ActiveRecord::Migration[5.2]
  def change
    add_column :documents, :load_manifest, :string
  end
end
