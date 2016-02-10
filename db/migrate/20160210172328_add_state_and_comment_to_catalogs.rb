class AddStateAndCommentToCatalogs < ActiveRecord::Migration
  def up
  	add_column :catalogs, :comment, :text
    add_column :catalogs, :state, :integer, :default => 3
    Catalog.all.each do |catalog|
      state_value = catalog.completed? ? 1 : 3
      catalog.update_column(:state, state_value)
      p "completed: #{catalog.completed}, state: #{catalog.state}"
    end
  end

  def down
    remove_column :catalogs, :state
  	remove_column :catalogs, :comment
  end
end
