class AddImageStatusToCatalogImages < ActiveRecord::Migration
  def change
  	add_column :catalog_images, :valid_image, :boolean

  	Rake::Task['models:add_catalog_image_status'].invoke
  end
end
