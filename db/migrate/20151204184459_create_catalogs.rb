class CreateCatalogs < ActiveRecord::Migration
  def change
    create_table :catalogs do |t|
      t.string :stand_number
      t.string :twitter
      t.string :facebook
      t.string :type
      t.integer :expositor_id
      
      t.timestamps null: false
    end
  end
end
