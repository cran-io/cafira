class ChangeColumnsFromAditionalServices < ActiveRecord::Migration
  def change
  	rename_column :aditional_services, :cuotas_sociales_cantidad, :catalogo_extra_cantidad
  end
end
