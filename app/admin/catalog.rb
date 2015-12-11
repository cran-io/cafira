ActiveAdmin.register Catalog do
  menu false
  permit_params :stand_number, :twitter, :facebook, :type
  controller do
    def edit
      @catalog = Expositor.find(params[:expositor_id]).catalog
    end

    def update
      update! do 
        flash[:message] = "Catálogo actualizado correctamente."
        edit_home_catalogo_path(resource.expositor) 
      end
    end
  end

  sidebar "Acciones del expositor", :priority => 0 do
    ul do
      li do
        span do
          link_to 'Datos del expositor',  edit_home_expositor_path(resource.expositor), :method => :get
        end
      end
      li do
        span do
          link_to 'Credenciales',  home_expositor_credentials_path(resource.expositor), :method => :get
        end
      end
      li do
        span do
          link_to 'Servicios Adicionales', edit_home_services_path(resource.expositor), :method => :get
        end
      end
      li do
        span do
          link_to 'Catálogo', edit_home_catalogo_path(resource.expositor), :method => :get
        end
      end
      li do
        span do
          'Infraestructura'
        end
      end
    end
  end

  form do |f|
    f.inputs 'Editar Catálogo' do
      f.input :stand_number, :label => "Número de stand"
      f.input :twitter
      f.input :facebook
    end
    f.actions do
      f.action(:submit)
    end
  end

end
