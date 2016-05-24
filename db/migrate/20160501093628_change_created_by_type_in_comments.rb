class ChangeCreatedByTypeInComments < ActiveRecord::Migration
  def change
    change_column :comments, :created_by, :string
  end
end
