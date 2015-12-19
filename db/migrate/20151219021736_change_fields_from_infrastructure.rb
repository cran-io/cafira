class ChangeFieldsFromInfrastructure < ActiveRecord::Migration
  def change
  	change_column :infrastructures, :alfombra, 'boolean USING CAST(alfombra AS boolean)'
  	add_column :infrastructures, :alfombra_tipo, :string
  end
end
