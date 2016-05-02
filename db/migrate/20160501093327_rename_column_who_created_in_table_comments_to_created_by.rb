class RenameColumnWhoCreatedInTableCommentsToCreatedBy < ActiveRecord::Migration
  def change
    rename_column :comments, :who_created, :created_by
  end
end
