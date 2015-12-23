class SetDefaultBooleanFieldsToFalse < ActiveRecord::Migration
	def up
	  change_column :infrastructures, :tarima, :boolean, :default => false
    change_column :infrastructures, :paneles, :boolean, :default => false
    change_column :infrastructures, :alfombra, :boolean, :default => false
    change_column :infrastructures, :completed, :boolean, :default => false

    change_column :catalogs, :completed, :boolean, :default => false

    change_column :aditional_services, :energia, :boolean, :default => false
    change_column :aditional_services, :estacionamiento, :boolean, :default => false
    change_column :aditional_services, :nylon, :boolean, :default => false
    change_column :aditional_services, :cuotas_sociales, :boolean, :default => false
    change_column :aditional_services, :catalogo_extra, :boolean, :default => false
    change_column :aditional_services, :completed, :boolean, :default => false

    change_column :credentials, :armador, :boolean, :default => false
    change_column :credentials, :personal_stand, :boolean, :default => false
    change_column :credentials, :foto_video, :boolean, :default => false
    change_column :credentials, :art, :boolean, :default => false
    change_column :credentials, :es_expositor, :boolean, :default => false
  end

	def down
	  change_column :infrastructures, :tarima, :boolean, :default => nil
    change_column :infrastructures, :paneles, :boolean, :default => nil
    change_column :infrastructures, :alfombra, :boolean, :default => nil
    change_column :infrastructures, :completed, :boolean, :default => nil
    
    change_column :catalogs, :completed, :boolean, :default => nil

    change_column :aditional_services, :energia, :boolean, :default => nil
    change_column :aditional_services, :estacionamiento, :boolean, :default => nil
    change_column :aditional_services, :nylon, :boolean, :default => nil
    change_column :aditional_services, :cuotas_sociales, :boolean, :default => nil
    change_column :aditional_services, :catalogo_extra, :boolean, :default => nil
    change_column :aditional_services, :completed, :boolean, :default => nil

    change_column :credentials, :armador, :boolean, :default => nil
    change_column :credentials, :personal_stand, :boolean, :default => nil
    change_column :credentials, :foto_video, :boolean, :default => nil
    change_column :credentials, :art, :boolean, :default => nil
    change_column :credentials, :es_expositor, :boolean, :default => nil
	end
end
