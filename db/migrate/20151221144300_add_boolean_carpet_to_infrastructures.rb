class AddBooleanCarpetToInfrastructures < ActiveRecord::Migration
  def change
  	add_column :infrastructures, :alfombra, :boolean
  end
end
