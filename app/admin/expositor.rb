ActiveAdmin.register Expositor do
  menu false
  permit_params :name, :email, :cuit

  controller do
    def scoped_collection
      if params[:exposition_id]
        @expositors = Exposition.find(params[:exposition_id]).expositors
      else
        @expositors = Expositor.all
      end
    end 
  end

  sidebar "Acciones del expositor", :priority => 0, :except => :index do
    ul do
      li do
        span do
          link_to 'Credenciales',  home_expositor_credentials_path(resource), :method => :get
        end
      end
      li do
        span do
          link_to 'Servicios Adicionales',  '', :method => :get
        end
      end
      li do
        span do
          link_to 'Catálogo',  '', :method => :get
        end
      end
      li do
        span do
          link_to 'Infraestructura',  '', :method => :get
        end
      end
    end
  end

  index do
    if params[:exposition_id]
      h2 "Expositors en \"" + Exposition.find(params[:exposition_id]).name + "\"" 
    else
      h2 "Expositors"
    end
    column "Nombre", :name
    column "Cuit", :cuit
    column "E-mail", :email
    actions
  end

  form do |f|
    f.semantic_errors
    f.inputs 'Expositor' do
      f.input :name, :label => "Nombre"
      f.input :email, :label => "E-mail"
      f.input :cuit, :label => "Cuit"
    end
    f.actions
  end

  show do
    attributes_table do
      row "Nombre" do
        resource.name
      end
      row "E-mail" do
        resource.email
      end
      row "Cuit" do
        resource.cuit
      end
    end
  end

  filter :name, :label => "Nombre"
  filter :cuit, :label => "Cuit"
  filter :email, :label => "Email"

end