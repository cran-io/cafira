ActiveAdmin.register AditionalService do
  menu false
  permit_params :energia, :energia_cantidad, :estacionamiento, :estacionamiento_cantidad, :nylon, :nylon_cantidad, :catalogo_extra
  config.batch_actions = false
    
  controller do
    after_action :set_aditional_catalog, :only => :update

    def edit
      @aditional_service = Expositor.find(params[:expositor_id]).aditional_service
      exposition = Rails.cache.read(:exposition_id)
      exposition = Exposition.find(exposition)
      @manual_url = exposition.exposition_files.find_by_file_type("manual").attachment.url
      @plan_url = exposition.exposition_files.find_by_file_type("plan_tiempos").attachment.url
      @bylaw_url = exposition.exposition_files.find_by_file_type("reglamento").attachment.url
    end

    def update
      update! do 
        flash[:message] = "Servicios adicionales actualizados correctamente."
        edit_home_services_path(resource.expositor) 
      end
    end
  
    private
    def set_aditional_catalog
      catalog = resource.expositor.catalog
      if resource.catalogo_extra?
        unless catalog.catalog_images.where("priority ILIKE ?", "%_adicional").any?
          catalog.update_columns(:completed => false)
          ['primaria_adicional', 'secundaria_adicional', 'secundaria_adicional', 'secundaria_adicional'].each do |priority|
            catalog.catalog_images << CatalogImage.new( :priority => priority )
          end
        end
      else
        catalog.catalog_images.where("priority ILIKE ?", "%_adicional").delete_all
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
          link_to 'Catálogo', edit_home_catalogo_path(resource.expositor), :method => :get
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
          link_to 'Infraestructura', edit_home_infrastruct_path(resource.expositor), :method => :get
        end
      end
    end
  end

   sidebar "Descargas", :priority => 1 do
    ul do
      li do
        span do
          link_to("Manual", manual_url)
        end
      end
      li do
        span do
          link_to("Plan de tiempos", plan_url)
        end
      end
      li do
        span do
          link_to("Reglamento técnico", bylaw_url)
        end
      end
    end
  end
  
  form do |f|
    f.inputs "Servicio adicional" do
      status = f.object.completed ? 'yes' : 'no'
      div :class => "status_tag #{status} completed_status_tag"  do
        f.object.completed ? "Sección completa" : "Hay campos incompletos";
      end
      f.input :energia, :label => "Energía"
      f.input :energia_cantidad, :label => "Energía cantidad", :input_html => { :step =>"0.5", :min => "0" }
      f.input :estacionamiento, :label => "Estacionamiento"
      f.input :estacionamiento_cantidad, :label => "Cantidad (estacionamiento)" 
      f.input :nylon, :label => "Nylon"
      f.input :catalogo_extra, :label => "Página de catálogo adicional"
    end
    f.actions do
      f.action(:submit)
    end

  end
end
