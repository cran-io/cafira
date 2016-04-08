class AddFantasynameToCatalogs < ActiveRecord::Migration
  def change
    add_column :catalogs, :fantasy_name, :string
  end
end
