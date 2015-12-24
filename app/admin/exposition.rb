ActiveAdmin.register Exposition do
  menu label: "Exposiciones"
  permit_params :ends_at, :initialized_at, :name, :active, :deadline_catalogs, :deadline_credentials, :deadline_infrastructures, :deadline_aditional_services, :exposition_files_attributes => [:file_type, :attachment, :attachment_file_name, :attachment_content_type, :attachment_file_size, :attachment_updated_at, :id]
  config.batch_actions = false
  
  controller do
    def new
      new! do
        exposition_files = Array.new
        ['reglamento', 'manual', 'plan_tiempos'].each do |type|
          exposition_files.push(ExpositionFile.new(:file_type => type))
        end
        resource.exposition_files = exposition_files
      end
    end

    def update
      update!{ home_expositions_path }
    end
    
    def create
      create! { home_expositions_path }
    end
  end

  index :download_links => [:csv] do
    h2 "Lista de exposiciones"
    br
    column "Nombre", :name
    column "Fecha de comienzo", :initialized_at
    column "Fecha de finalización", :ends_at
    column "Deadlines" do |exposition|
      div do
        span do
          strong do
            "Deadline catálogo: "
          end
        end
        span do
          exposition.deadline_catalogs || "-"
        end
      end
      div do
        span do
          strong do
            "Deadline credenciales: "
          end
        end
        span do
          exposition.deadline_credentials || "-"
        end
      end
      div do
        span do
          strong do
            "Deadline serv. adicionales: "
          end
        end
        span do
            exposition.deadline_aditional_services || "-"
        end
      end
      div do
        span do
          strong do
            "Deadline infraestructura: "
          end
        end
        span do
          exposition.deadline_infrastructures || "-"
        end
      end
    end
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
        link_to "Eliminar", home_exposition_path(exposition.id), :method => :delete
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
    f.inputs 'Datos de la exposición' do
      f.input :name, :label => "Nombre"
      f.input :initialized_at, :label => "Fecha de comienzo", :as => :datepicker, :datepicker_options => { :min_date => Date.today }
      f.input :ends_at, :label => "Fecha de finalización", :as => :datepicker, :datepicker_options => { :min_date => Date.today }
      f.input :deadline_catalogs, :label => "Deadline fotos e información catálogo", :as => :datepicker, :datepicker_options => { :min_date => Date.today }
      f.input :deadline_credentials, :label => "Deadline carga de credenciales", :as => :datepicker, :datepicker_options => { :min_date => Date.today }
      f.input :deadline_aditional_services, :label => "Deadline servicios adicionales", :as => :datepicker, :datepicker_options => { :min_date => Date.today }
      f.input :deadline_infrastructures, :label => "Deadline infraestructura", :as => :datepicker, :datepicker_options => { :min_date => Date.today }
      f.has_many :exposition_files, :heading => "Archivos", :allow_destroy => false, :new_record => false, :enctype => "multipart/form-data"  do |ff|
        case ff.object.file_type
        when 'reglamento'
          label = 'Reglamento técnico'
        when 'plan_tiempos'
          label = 'Plan de tiempos'
        else
          label = 'Manual'
        end
        ff.input :attachment, :label => "#{label}", :as => :file, :require => false, 
        :hint => ff.object.attachment.present? ? ff.object.attachment_file_name : content_tag(:span, "No hay un #{label} subido aún")
        ff.input :file_type, :input_html => { :value => ff.object.file_type }, :as => :hidden
      end
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
  filter :active, :label => "Activo", :collection => [["Si", true], ["No", false]]
end
