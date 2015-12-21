class ChangeFieldsFromInfrastructure < ActiveRecord::Migration
  def change
  	remove_column :infrastructures, :alfombra
  	add_column :infrastructures, :alfombra_tipo, :string
  end
end
