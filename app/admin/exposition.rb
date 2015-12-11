ActiveAdmin.register Exposition do
  menu label: "Exposiciones"
  permit_params :ends_at, :initialized_at, :name, :active, :deadline_catalogs, :deadline_credentials, :deadline_infrastructures, :deadline_aditional_services
  config.batch_actions = false
  
  controller do
    def update
      update!{ home_expositions_path }
    end
    def create
      create!{ home_expositions_path }
    end
  end

  index :download_links => [:csv] do
    h2 "Lista de exposiciones"
    br
    column "Nombre", :name
    column "Fecha de comienzo", :initialized_at
    column "Fecha de finalización", :ends_at
    column "Deadline catálogo", :deadline_catalogs
    column "Deadline credenciales", :deadline_credentials
    column "Deadline serv. adicionales", :deadline_aditional_services
    column "Deadline infraestructura", :deadline_infrastructures
    column "Activo", :active, :class => 'text-right'
    column "Acciones" do |exposition|
      span do 
        link_to 'Ver', {:controller => 'home/expositors', :action => 'index', :exposition_id => exposition.id}, :method => :get
      end
      span do 
        "|"
      end
      span do 
        link_to 'Editar', edit_home_exposition_path(exposition), :method => :get
      end
      span do 
        "|"
      end
      span do
        link_to (exposition.active? ? 'Desactivar' : 'Activar'), activate_home_exposition_path(exposition) , :method => :post
      end
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs 'Editar Exposición' do
      f.input :name, :label => "Nombre"
      f.input :initialized_at, :label => "Fecha de comienzo", :as => :datepicker, :datepicker_options => { :min_date => Date.today }
      f.input :ends_at, :label => "Fecha de finalización", :as => :datepicker, :datepicker_options => { :min_date => Date.today }
      f.input :deadline_catalogs, :label => "Deadline fotos e información catálogo", :as => :datepicker, :datepicker_options => { :min_date => Date.today }
      f.input :deadline_credentials, :label => "Deadline carga de credenciales", :as => :datepicker, :datepicker_options => { :min_date => Date.today }
      f.input :deadline_aditional_services, :label => "Deadline servicios adicionales", :as => :datepicker, :datepicker_options => { :min_date => Date.today }
      f.input :deadline_infrastructures, :label => "Deadline infraestructura", :as => :datepicker, :datepicker_options => { :min_date => Date.today }
    end
    f.actions
  end

  show do
    attributes_table do
      row "Nombre" do
        resource.name
      end
      row "Fecha de comienzo" do
        resource.initialized_at
      end
      row "Fecha de finalización" do
        resource.ends_at
      end
      row "Estado" do
        resource.active? ? "Activo" : "No activo"
      end
    end
  end

  #CONTROLLER ACTIONS
  member_action :activate, method: :post do
    if resource.active?
      resource.active = false
      resource.save
    else
      resource.active = true
      resource.save
    end
    redirect_to home_expositions_path, notice: "Exposición #{resource.name} actualizada satisfactoriamente."
  end

  #FILTERS
  filter :name, :label => "Nombre exposición"
  filter :initialized_at, :label => "Comenzada el"
  filter :ends_at, :label => "Termina el"
  filter :active, :label => "Activo"
end
