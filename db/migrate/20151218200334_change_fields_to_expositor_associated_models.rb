class ChangeFieldsToExpositorAssociatedModels < ActiveRecord::Migration
  def change
  	remove_column :aditional_services, :nylon_cantidad
  	add_column :catalogs, :description, :text
  	add_column :catalogs, :phone_number, :string
  	add_column :catalogs, :aditional_phone_number, :string
  	add_column :catalogs, :email, :string
  	add_column :catalogs, :aditional_email, :string
  	add_column :catalogs, :website, :string
  	add_column :catalogs, :address, :string
  	add_column :catalogs, :city, :string
  	add_column :catalogs, :province, :string
  	add_column :catalogs, :zip_code, :string
  	add_column :blueprint_files, :comment, :text
  end
end
