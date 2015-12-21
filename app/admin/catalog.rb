ActiveAdmin.register Catalog do
  menu false
  permit_params :stand_number, :twitter, :facebook, :type, :description, :phone_number, :aditional_phone_number, :email, :aditional_email, :website, :address, :city, :province, :zip_code, :catalog_images_attributes => [:attachment, :attachment_file_name, :attachment_content_type, :attachment_file_size, :attachment_updated_at, :id]
  config.batch_actions = false

  controller do
    def edit
      @catalog = Expositor.find(params[:expositor_id]).catalog
      exposition = Rails.cache.read(:exposition_id)
      exposition = Exposition.find(exposition)
      @manual_url = exposition.exposition_files.find_by_file_type("manual").attachment.url
      @plan_url = exposition.exposition_files.find_by_file_type("plan_tiempos").attachment.url
      @bylaw_url = exposition.exposition_files.find_by_file_type("reglamento").attachment.url
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

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs 'Editar Catálogo' do
      status = f.object.completed ? 'yes' : 'no'
      div :class => "status_tag #{status} completed_status_tag"  do
        f.object.completed ? "Sección completa" : "Hay campos incompletos";
      end
      if current_user.type == 'AdminUser'
        f.input :stand_number, :label => "Número de stand"
      else
        f.input :stand_number, :label => "Número de stand", :input_html => { :disabled => true }
      end
      f.input :twitter
      f.input :facebook
      f.input :phone_number, :label => "Teléfono 1", :placeholder => "Formato: +54-11-4888-8888"
      f.input :aditional_phone_number, :label => "Teléfono 2", :placeholder => "Formato: +54-11-4888-8888"
      f.input :email, :label => "E-mail", :placeholder => "mail@ejemplo.com"
      f.input :aditional_email, :label => "E-mail adicional", :placeholder => "mail@ejemplo.com"
      f.input :website, :label => "Página web", :placeholder => "http://www.ejemplo.com/"
      f.input :address, :label => "Dirección"
      f.input :city, :label => "Ciudad"
      f.input :province, :label => "Provincia"
      f.input :zip_code, :label => "Codigo postal"
      f.input :description, :label => "Descripción catálogo (200 caracteres máx)", :input_html => { :maxlength => "200" }
      f.has_many :catalog_images, :heading => "Subir imágenes", :new_record => false, :html => { :enctype => "multipart/form-data" } do |ff| 
        ff.input :priority, :label => "Tipo de imagen", :input_html => { :disabled => true }
        ff.input :attachment, :label => "Imagen", :as => :file, :require => false, :hint => ff.object.attachment.present? ? image_tag(ff.object.attachment.url, :style => "width:200px") : content_tag(:span, "No hay imagen subida aún")
      end
    end
    f.actions do
      f.action(:submit)
    end
  end

end
