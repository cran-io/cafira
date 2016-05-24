class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :architect_id
      t.integer :blueprint_file_id
      t.text :comment

      t.timestamps null: false
    end
  end
end
