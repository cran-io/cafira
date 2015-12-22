class ChangeBlueprintStateField < ActiveRecord::Migration
  def up
  	change_column :blueprint_files, :state, 'integer USING CAST(state AS integer)'
  end

  def down
  	change_column :blueprint_files, :state, 'boolean USING CAST(state AS boolean)'
  end
end
