class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :type
      t.string :name
      t.string :cuit

      t.timestamps null: false
    end
  end
end
