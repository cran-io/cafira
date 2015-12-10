ActiveAdmin.register AditionalService do
  menu false
  permit_params :energia, :energia_cantidad, :estacionamiento, :estacionamiento_cantidad, :nylon, :nylon_cantidad, :cuotas_sociales, :cuotas_sociales_cantidad, :catalogo_extra
  
  controller do
    def edit
      @aditional_service = Expositor.find(params[:expositor_id]).aditional_service
    end

    def update
      update! { edit_home_services_path(resource) }
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
          'Catálogo'
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
    f.inputs "Servicio adicional" do
      f.input :energia, :label => "Energía"
      f.input :energia_cantidad, :label => "Energía cantidad"
      f.input :estacionamiento, :label => "Estacionamiento"
      f.input :estacionamiento_cantidad, :label => "Cantidad (estacionamiento)" 
      f.input :nylon, :label => "nylon"
      f.input :nylon_cantidad, :label => "Cantidad (nylon)"
      f.input :cuotas_sociales, :label => "Cuotas sociales"
      f.input :cuotas_sociales_cantidad, :label => "Cantidad (cuotas sociales)"
      f.input :catalogo_extra, :label => "Catálogo extra"
    end
    f.actions
  end
end
