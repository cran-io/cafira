class CreateBlueprintFiles < ActiveRecord::Migration
  def change
    create_table :blueprint_files do |t|

      t.timestamps null: false
    end
  end
end
