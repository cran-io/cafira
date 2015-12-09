ActiveAdmin.register Expositor, :as => "Expositores" do
  controller do
    def scoped_collection
      if params[:exposition_id]
        @expositors = Exposition.find(params[:exposition_id]).expositors
      else
        @expositors = Expositor.all
      end
    end 
  end

  index do
    if params[:exposition_id]
      h2 "Expositores en \"" + Exposition.find(params[:exposition_id]).name + "\"" 
    else
      h2 "Expositores"
    end
    column "Nombre", :name
    column "Cuit", :cuit
    column "E-mail", :email
    column "Credenciales" do |expositor|
    end
  end


  filter :name, :label => "Nombre"
  filter :cuit, :label => "Cuit"
  filter :email, :label => "Email"

end