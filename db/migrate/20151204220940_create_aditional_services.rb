class CreateAditionalServices < ActiveRecord::Migration
  def change
    create_table :aditional_services do |t|
      t.boolean :energia
      t.integer :energia_cantidad
      t.boolean :estacionamiento
      t.integer :estacionamiento_cantidad
      t.boolean :nylon
      t.integer :nylon_cantidad
      t.boolean :cuotas_sociales
      t.integer :cuotas_sociales_cantidad
      t.boolean :catalogo_extra
      t.integer :coutas_sociales_cantidad
      t.integer :expositor_id
      
      t.timestamps null: false
    end
  end
end
