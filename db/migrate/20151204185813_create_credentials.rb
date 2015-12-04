class CreateCredentials < ActiveRecord::Migration
  def change
    create_table :credentials do |t|
	  t.string :name
      t.boolean :armador
      t.boolean :personal_stand
      t.boolean :expositor
      t.boolean :foto_video
      t.integer :expositor_id
      
      t.timestamps null: false
    end
  end
end
