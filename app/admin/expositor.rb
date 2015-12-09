ActiveAdmin.register Expositor, :as => "Expositores" do
  menu false
  controller do
    def scoped_collection
      if params[:exposition_id]
        @expositors ||= Exposition.find(params[:exposition_id]).expositors
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
    column "Catálogo" do |expositor|
      span do
        link_to 'Editar', {:controller => 'home/catalogs', :action => 'index', :expositor => expositor.id}, :method => :get
      end
    end
    column "Credenciales" do |expositor|
      span do
        link_to 'Editar', {:controller => 'home/credentials', :action => 'index', :expositor => expositor.id}, :method => :get
      end
    end
    column "Infrastructura" do |expositor|
      span do
        link_to 'Editar', {:controller => 'home/infrastructures', :action => 'index', :expositor => expositor.id}, :method => :get
      end
    end
    column "Servicios adicionales" do |expositor|
      span do
        link_to 'Editar', {:controller => 'home/aditional_services', :action => 'index', :expositor => expositor.id}, :method => :get
      end
    end
  end


  filter :name, :label => "Nombre"
  filter :cuit, :label => "Cuit"
  filter :email, :label => "Email"

end