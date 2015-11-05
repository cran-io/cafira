class CreateExpositionExpositors < ActiveRecord::Migration
  def change
    create_table :exposition_expositors do |t|

      t.integer :exposition_id
      t.integer :expositor_id

      t.timestamps null: false
    end
  end
end
