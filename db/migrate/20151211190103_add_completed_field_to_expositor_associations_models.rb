class AddCompletedFieldToExpositorAssociationsModels < ActiveRecord::Migration
  def change
  	add_column :catalogs, :completed, :boolean, :default => false
  	add_column :infrastructures, :completed, :boolean, :default => false
  	add_column :aditional_services, :completed, :boolean, :default => false
  end
end
