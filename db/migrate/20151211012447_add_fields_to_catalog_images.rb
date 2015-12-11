class AddFieldsToCatalogImages < ActiveRecord::Migration
  def change
  	change_table :catalog_images do |t|
  	  t.attachment :attachment
  	  t.string :priority
  	  t.integer :catalog_id
  	end
  end
end
