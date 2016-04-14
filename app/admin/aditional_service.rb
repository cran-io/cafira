ActiveAdmin.register AditionalService do
  permit_params :energia, :energia_cantidad, :estacionamiento, :estacionamiento_cantidad, :nylon, :nylon_cantidad, :catalogo_extra
  menu :if  => proc {current_user.type != 'Expositor' && (current_user.type == 'Architect' || current_user.type == 'AdminUser') }
  config.batch_actions = false
  actions :all, :except => [:new, :create]

  controller do
    after_action :set_aditional_catalog, :only => :update
    before_action :redirect_to_home, :only => :index

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

    def redirect_to_home
      redirect_to root_path if current_user.type != 'AdminUser' && current_user.type != 'Architect'
    end
  end

  sidebar "Acciones del expositor", :priority => 0, :only => :edit do
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

   sidebar "Descargas", :priority => 1, :only => :edit do
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

  index :download_links => [:csv] do
    column "Completo", :completed
    column "Expositor" do |aditional_service|
      aditional_service.expositor.name_and_email
    end
    column "Energía", :energia
    column "Cantidad energía" do |aditional_service|
      aditional_service.energia_cantidad.nil? ? '-' : aditional_service.energia_cantidad
    end
    column :estacionamiento
    column "Cantidad de estacionamientos" do |aditional_service|
      aditional_service.estacionamiento_cantidad.nil? ? '-' : aditional_service.estacionamiento_cantidad
    end
    column :nylon
    column "Catálogo adicional", :catalogo_extra
  end

  form do |f|
    f.inputs "Servicio adicional" do
      status = f.object.completed ? 'yes' : 'no'
      div :class => "status_tag #{status} completed_status_tag"  do
        f.object.completed ? "Sección completa" : "Hay campos incompletos";
      end
      f.input :energia, :label => "Energía adicional", :as => :select, :collection => [["Si",true],["No",false]], :include_blank => '-'
      f.input :energia_cantidad, :label => "Energía cantidad", :input_html => { :step =>"0.5", :min => "0" }
      f.input :estacionamiento, :label => "Estacionamiento adicional", :as => :select, :collection => [["Si",true],["No",false]], :include_blank => '-'
      f.input :estacionamiento_cantidad, :label => "Cantidad (estacionamiento)"
      f.input :nylon, :label => "Nylon", :as => :select, :collection => [["Si",true],["No",false]], :include_blank => '-'
      f.input :catalogo_extra, :label => "Página de catálogo adicional", :as => :select, :collection => [["Si",true],["No",false]], :include_blank => '-'
    end
    f.actions do
      f.action(:submit)
    end

  end

  csv do
    column "Completo" do |aditional_service|
      aditional_service.completed?  ? "Si" : "No"
    end
    column "Expositor" do |aditional_service|
      aditional_service.expositor.name_and_email
    end
    column "Energía" do |aditional_service|
      aditional_service.energia? ? "Si" : "No"
    end
    column "Cantidad energía" do |aditional_service|
      aditional_service.energia_cantidad
    end
    column "Estacionamiento" do |aditional_service|
      aditional_service.estacionamiento? ? "Si" : "No"
    end
    column "Cantidad estacionamiento" do |aditional_service|
      aditional_service.estacionamiento_cantidad
    end
    column "Nylon" do |aditional_service|
      aditional_service.nylon? ? "Si" : "No"
    end
    column "Catálogo adicional" do |aditional_service|
      aditional_service.catalogo_extra? ? "Si" : "No"
    end
  end

  filter :completed, :label => "Completo", :collection => [["Si", true], ["No", false]]
  filter :energia, :label => "Energía", :collection => [["Si", true], ["No", false]]
  filter :estacionamiento, :label => "Estacionamiento", :collection => [["Si", true], ["No", false]]
  filter :nylon, :label => "Nylon", :collection => [["Si", true], ["No", false]]
  filter :catalogo_extra, :label => "Catálogo adicional", :collection => [["Si", true], ["No", false]]
end
