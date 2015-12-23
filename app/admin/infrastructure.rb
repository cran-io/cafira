ActiveAdmin.register Infrastructure do
  config.batch_actions = false
  permit_params :alfombra, :alfombra_tipo, :tarima, :paneles, :blueprint_files_attributes => [:attachment, :attachment_file_name, :attachment_content_type, :attachment_file_size, :attachment_updated_at, :id]
  actions :all, :except => [:new, :create]
  menu false if proc {current_user.type = 'Expositor'}

  member_action :download_infrastructure, :method => :get do
    tmpfile = resource.download_infrastructure
    send_file(tmpfile, :filename => "#{resource.expositor.name}_datos_infraestructura.zip", :type => "application/zip")
    tmpfile.close
  end

  controller do
    def edit
      @infrastructure = Expositor.find(params[:expositor_id]).infrastructure
      exposition = Rails.cache.read(:exposition_id)
      exposition = Exposition.find(exposition)
      @manual_url = exposition.exposition_files.find_by_file_type("manual").attachment.url
      @plan_url = exposition.exposition_files.find_by_file_type("plan_tiempos").attachment.url
      @bylaw_url = exposition.exposition_files.find_by_file_type("reglamento").attachment.url
    end

    def update
      update! do 
        flash[:message] = "Datos de infraestructura actualizados correctamente."
        edit_home_infrastruct_path(resource.expositor) 
      end
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
  
  index :download_links => false do 
    column "Completo", :completed
    column "Expositor" do |infrastructure|
      infrastructure.expositor.name_and_email
    end
    column :tarima
    column :paneles
    column :alfombra
    column "Tipo de alfombra", :alfombra_tipo do |infrastructure|
      infrastructure.alfombra_tipo? ? infrastructure.alfombra_tipo.camelize : "-" 
    end
    column "Planos" do |infrastructure|
      infrastructure.blueprint_files.each_with_index do |bp_file, index|
        div do
          span do
            strong do
              "Plano #{index + 1}: "
            end
          end
          span do
              link_to((bp_file.attachment_file_name || ""), bp_file.attachment.url)
          end
        end
      end
    end
    column "Acciones" do |infrastructure|
      div do
        span do
            link_to "Descargar", download_infrastructure_home_infrastructure_path(infrastructure)
        end
      end if infrastructure.completed?
    end
  end

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs 'Editar Catálogo' do
      status = f.object.completed ? 'yes' : 'no' 
      div :class => "status_tag #{status} completed_status_tag"  do
        f.object.completed ? "Sección completa" : "Hay campos incompletos";
      end
      f.input :alfombra
      f.input :alfombra_tipo, :label => "Tipo de alfombra", :as => :select, :collection => [["Estándar","estandar"],["Otra", "otra"]], :include_blank => false, :allow_blank => false, :hint => "comunicarse con el organizador para saber disponibilidad."
      f.input :tarima
      f.input :paneles
      f.has_many :blueprint_files, :heading => "Subir planos", :new_record => false, :html => { :enctype => "multipart/form-data" } do |ff| 
        label = status = ''
        case ff.object.state
        when 0
          status = '(NO APROBADO). Debe volver a subir el plano.'
          label  = 'label-red'
          ff.input :attachment, :label => "Plano <span class='#{label}'>#{status}</span>".html_safe, :as => :file, :require => false, 
          :hint => ff.object.attachment.present? ? "Justificación: " + ff.object.comment : content_tag(:span, "No hay un plano subido aún")
        when 1
          status = '(APROBADO)'
          label  = 'label-green'
          ff.input :attachment_file_name, :label => "Plano <span class='#{label}'>#{status}</span>".html_safe, :input_html => { :disabled => true }
        when 2
          status = '(PRE APROBADO)'
          label  = 'label-grey'
          ff.input :attachment, :label => "Plano <span class='#{label}'>#{status}</span>".html_safe, :as => :file, :require => false, 
          :hint => ff.object.attachment.present? ? "Justificación: " + ff.object.comment : content_tag(:span, "No hay un plano subido aún")
        else
          status = '(PENDIENTE A REVISIÓN)'
          label  = 'label-orange'
          ff.input :attachment, :label => "Plano <span class='#{label}'>#{status}</span>".html_safe, :as => :file, :require => false, 
          :hint => ff.object.attachment.present? ? ff.object.attachment_file_name : content_tag(:span, "No hay un plano subido aún")
        end
      end
    end
    f.actions do
      f.action(:submit)
    end
  end


  filter :tarima, :collection => [['Si', true],['No', false]]
  filter :paneles, :collection => [['Si', true],['No', false]]
  filter :alfombra, :collection => [['Si', true],['No', false]]
  filter :alfombra_tipo, :as => :select, :collection => [['Estándar', 'estandar'],['Otra','otra']]
end
  