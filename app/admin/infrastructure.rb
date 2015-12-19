ActiveAdmin.register Infrastructure do
  menu false
  config.batch_actions = false
  permit_params :alfombra, :alfombra_tipo, :tarima, :paneles, :blueprint_files_attributes => [:attachment, :attachment_file_name, :attachment_content_type, :attachment_file_size, :attachment_updated_at, :id]
  
  controller do
    def edit
      @infrastructure = Expositor.find(params[:expositor_id]).infrastructure
    end

    def update
      update! do 
        flash[:message] = "Datos de infraestructura actualizados correctamente."
        edit_home_infrastruct_path(resource.expositor) 
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
        unless ff.object.attachment_file_name.nil?
          case ff.object.state
          when true
            status = '(APROBADO)'
            label  = 'label-green'
          when false
            status = '(NO APROBADO). Debe volver a subir el plano.'
            label  = 'label-red'
          else
            status = '(PENDIENTE A REVISIÓN)'
            label  = 'label-orange'
          end
        end
        if ff.object.state.nil?
          ff.input :attachment, :label => "Plano <span class='#{label}'>#{status}</span>".html_safe, :as => :file, :require => false, 
          :hint => ff.object.attachment.present? ? ff.object.attachment_file_name : content_tag(:span, "No hay un plano subido aún")
        elsif !ff.object.state
          ff.input :attachment, :label => "Plano <span class='#{label}'>#{status}</span>".html_safe, :as => :file, :require => false, 
          :hint => ff.object.attachment.present? ? "Justificación: " + ff.object.comment : content_tag(:span, "No hay un plano subido aún")
        else
          ff.input :attachment_file_name, :label => "Plano <span class='#{label}'>#{status}</span>".html_safe, :input_html => { :disabled => true }
        end
      end
    end
    f.actions do
      f.action(:submit)
    end
  end

end
  