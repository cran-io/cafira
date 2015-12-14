ActiveAdmin.register Infrastructure do
  menu false
  config.batch_actions = false
  permit_params :alfombra, :tarima, :paneles, :blueprint_files_attributes => [:attachment, :attachment_file_name, :attachment_content_type, :attachment_file_size, :attachment_updated_at, :id]
  
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
      f.input :alfombra
      f.input :tarima
      f.input :paneles
      f.has_many :blueprint_files, :heading => "Subir planos", :new_record => false, :html => { :enctype => "multipart/form-data" } do |ff| 
        ff.input :attachment, :label => "Plano", :as => :file, :require => false, :hint => ff.object.attachment.present? ? ff.object.attachment_file_name : content_tag(:span, "No hay un plano subido aún")
      end
    end
    f.actions do
      f.action(:submit)
    end
  end

end
  