class AddReasonToComments < ActiveRecord::Migration
  def change
    add_column :comments, :reason, :integer
    remove_column :catalogs, :reason
  end
end
