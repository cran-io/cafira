class CreateInfrastructures < ActiveRecord::Migration
  def change
    create_table :infrastructures do |t|
      t.string :alfombra
      t.boolean :tarima
      t.boolean :paneles

      t.timestamps null: false
    end
  end
end
