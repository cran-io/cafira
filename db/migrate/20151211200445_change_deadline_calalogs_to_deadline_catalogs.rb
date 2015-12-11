class ChangeDeadlineCalalogsToDeadlineCatalogs < ActiveRecord::Migration
  def change
    rename_column :expositions, :deadline_calalogs, :deadline_catalogs
  end
end
