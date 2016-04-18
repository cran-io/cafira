class AddCatalogTypeToCatalogs < ActiveRecord::Migration
  def change
    add_column :catalogs, :catalog_type, :string
  end
end
