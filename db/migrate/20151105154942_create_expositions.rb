class CreateExpositions < ActiveRecord::Migration
  def change
    create_table :expositions do |t|
      t.string :name 
      t.boolean :active, :default => false
      t.datetime :initializated_at

      t.timestamps null: false
    end
  end
end
