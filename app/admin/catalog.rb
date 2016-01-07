ActiveAdmin.register Catalog do
  permit_params :stand_number, :twitter, :facebook, :type, :description, :phone_number, :aditional_phone_number, :email, :aditional_email, :website, :address, :city, :province, :zip_code, :catalog_images_attributes => [:attachment, :attachment_file_name, :attachment_content_type, :attachment_file_size, :attachment_updated_at, :id]
  config.batch_actions = false
  actions :all, :except => [:new, :create]
  menu :if  => proc {current_user.type != 'Expositor' && (current_user.type == 'Designer' || current_user.type == 'AdminUser') }

  member_action :download_catalog, :method => :get do
    tmpfile = resource.download_catalog
    send_file(tmpfile, :filename => "#{resource.expositor.name}_datos_catalogo.zip", :type => "application/zip")
    tmpfile.close
  end

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
    column "Expositor" do |catalog|
      catalog.expositor.name
    end
    column "Stand" do |catalog|
      catalog.stand_number? ? catalog.stand_number : "-"
    end
    column "Completo", :completed, :class => 'text-right'
    column "Internet" do |catalog|
      div do
        span do
          strong do
            "Email: "
          end
        end
        span do
            catalog.email || '-'
        end
      end
      div do
        span do
          strong do
            "Email adicional: "
          end
        end
        span do
            catalog.aditional_email || '-'
        end
      end
      div do
        span do
          strong do
            "Página web: "
          end
        end
        span do
          catalog.website || '-'
        end
      end
      div do
        span do
          strong do
            "Facebook: "
          end
        end
        span do
          catalog.facebook || '-'
        end
      end
      div do
        span do
          strong do
            "Twitter: "
          end
        end
        span do
            catalog.twitter || '-'
        end
      end
    end
    column "Teléfonos" do |catalog|
      div do
        span do
          strong do
            "Tel. 1: "
          end
        end
        span do
            catalog.phone_number || '-'
        end
      end
      div do
        span do
          strong do
            "Teĺ. 2: "
          end
        end
        span do
            catalog.aditional_phone_number || '-'
        end
      end
    end
    column "Locación" do |catalog|
      div do
        span do
          strong do
            "Ciudad: "
          end
        end
        span do
            catalog.city || '-'
        end
      end
      div do
        span do
          strong do
            "Provincia: "
          end
        end
        span do
            catalog.province || '-'
        end
      end
      div do
        span do
          strong do
            "Código postal: "
          end
        end
        span do
            catalog.zip_code || '-'
        end
      end
    end
    column "Imágenes" do |catalog|
      catalog.catalog_images.each do |image|
        div do
          span do
            strong do
              "#{image.priority.camelize}: "
            end
          end
          span do
              image.attachment.present? ? link_to((image.attachment_file_name || ""), image.attachment.url) : "-"
          end
        end
      end
    end
    column "Acciones" do |catalog|
      div do
        span do
            link_to "Descargar", download_catalog_home_catalog_path(catalog)
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
        if ff.object.attachment.present?
          dimensions = Paperclip::Geometry.from_file(ff.object.attachment)
          image_size_error = "<span class='label-red'>(Tamaño de imagen inválida, mínimo 600px x 600px)</span>" if dimensions.width < 600 || dimensions.height < 600
        end 
        ff.input :attachment, :label => "Imagen #{image_size_error}".html_safe, :as => :file, :require => false, :hint => ff.object.attachment.present? ? image_tag(ff.object.attachment.url, :style => "width:200px") : content_tag(:span, "No hay imagen subida aún")
     
      end
    end
    f.actions do
      f.action(:submit)
    end
  end
  filter :completed, :label => "Completado", :collection => [["Si", true], ["No", false]]
  filter :stand_number, :label => "Nro stand"
  filter :email
  filter :twitter
  filter :facebook
  filter :address, :label => "Dirección"
end
