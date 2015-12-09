class ChangeCredentialAttributes < ActiveRecord::Migration
  def change
  	remove_column :credentials, :expositor
  	add_column :credentials, :art, :boolean 
  	add_column :credentials, :es_expositor, :boolean
  	add_column :credentials, :fecha_alta, :date
  end
end

