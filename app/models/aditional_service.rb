class AditionalService < ActiveRecord::Base
  belongs_to :expositor
  before_update :verify_fields
  private
  def verify_fields
    status = true
    if (energia == true && energia_cantidad.nil?) || (estacionamiento == true && estacionamiento_cantidad.nil?) || (nylon == true && nylon_cantidad.nil?) || (catalogo_extra == true && catalogo_extra_cantidad.nil?)
    	status = false
  	end
  	self.completed = status
  	nil
  end
end
