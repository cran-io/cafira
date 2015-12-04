class CreateBlueprintFiles < ActiveRecord::Migration
  def change
    create_table :blueprint_files do |t|
      t.boolean :state
      t.attachment :attachment
      t.integer :infrastructure_id

      t.timestamps null: false
    end
  end
end
