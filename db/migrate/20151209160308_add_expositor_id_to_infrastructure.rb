class AddExpositorIdToInfrastructure < ActiveRecord::Migration
  def change
  	add_column :infrastructures, :expositor_id, :integer
  end
end
