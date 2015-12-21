class CreateExpositionFiles < ActiveRecord::Migration
  def change
    create_table :exposition_files do |t|
      t.string :file_type
      t.attachment :attachment
      t.integer :exposition_id
      
      t.timestamps null: false
    end
  end
end
