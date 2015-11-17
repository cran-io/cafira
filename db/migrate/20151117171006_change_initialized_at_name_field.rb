class ChangeInitializedAtNameField < ActiveRecord::Migration
  def change
  	rename_column :expositions, :initializated_at, :initialized_at
  end
end
