class CreateCatalogImages < ActiveRecord::Migration
  def change
    create_table :catalog_images do |t|

      t.timestamps null: false
    end
  end
end
