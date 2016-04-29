class AddWhoCreatedToComments < ActiveRecord::Migration
  def change
    add_column :comments, :who_created, :integer
  end
end
