ActiveAdmin.register Catalog do
  permit_params :stand_number, :twitter, :facebook, :type, :description, :phone_number, :aditional_phone_number, :email, :aditional_email, :website, :address, :city, :province, :zip_code, :fantasy_name, :catalog_type, :catalog_images_attributes => [:attachment, :attachment_file_name, :attachment_content_type, :attachment_file_size, :attachment_updated_at, :id]
  actions :all, :except => [:new, :create, :show]
  menu :if  => proc {current_user.type != 'Expositor' && (current_user.type == 'Designer' || current_user.type == 'AdminUser') }
  config.batch_actions = false
  
  Exposition.all.each do |exposition|
    scope(exposition.name) do |scope|
      expositors = ExpositionExpositor.where(:exposition_id => exposition.id).map(&:expositor_id)
      scope.where(:expositor_id => expositors)
    end
  end

  member_action :pending, method: :post do
    resource.update_columns(:state => 3, :comment => nil, :completed => false)
    redirect_to home_catalogs_path
  end

  member_action :approve, method: :post do
    resource.update_columns(:state => 1, :comment => nil, :completed => true)
    redirect_to home_catalogs_path
  end

  member_action :disapprove, method: :post do
    resource.update_columns(:state => 0, :comment => params[:justification], :completed => false)
    ExpositorMailer.catalog_email(resource.expositor, params[:justification], 'disapproved').deliver_later(wait: 10)
    render :json => { :url => home_catalogs_path }
  end


  member_action :pre_approve, method: :post do
    resource.update_columns(:state => 2, :comment => params[:justification], :completed => false)
    ExpositorMailer.catalog_email(resource.expositor, params[:justification], 'pre_approved').deliver_later(wait: 10)
    render :json => { :url => home_catalogs_path }
  end

  member_action :download_catalog, :method => :get do
    tmpfile = resource.download_catalog
    send_file(tmpfile, :filename => "#{resource.expositor.name}_datos_catalogo.zip", :type => "application/zip")
    tmpfile.close
  end

  controller do
    before_action :redirect_to_home, :only => :index
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

    private
    def redirect_to_home
      redirect_to root_path if current_user.type != 'AdminUser' && current_user.type != 'Designer'
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
    column "Expositor" do |catalog|
      catalog.expositor.name
    end
    column "Completo", :completed, :class => 'text-right'
    column "Estado", :state do |catalog|
      case catalog.state
      when 0
        status_tag 'Desaprobado', :red
      when 1
        status_tag 'Aprobado', :yes
      when 2
        status_tag 'Pre aprobación', :grey
      else
        status_tag 'Pendiente', :orange
      end
    end
    column "General" do |catalog|
      div do
        span do
          strong do
            "Nombre de fantasía: "
          end
        end
        span do
            catalog.fantasy_name || '-'
        end
      end
      div do
        span do
          strong do
            "Stand: "
          end
        end
        span do
            catalog.stand_number || '-'
        end
      end
      div do
        span do
          strong do
            "Tipo de catálogo: "
          end
        end
        span do
            catalog.catalog_type || '-'
        end
      end
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
    column "Imágenes" do |catalog|
      catalog.catalog_images.each do |image|
        div do
          span do
            strong do
              "#{image.priority.humanize}: "
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
          link_to 'Aprobar', approve_home_catalog_path(catalog), :method => :post
        end
        span do
          ' | '
        end
        span do
          link_to 'Desaprobar', 'javascript:void(0);', :method => :post, :class => "disapprove_catalog", :data => { :path => disapprove_home_catalog_path(catalog)}
        end
        span do
          ' | '
        end
        span do
          link_to 'Pre aprobar', 'javascript:void(0);', :method => :post, :class => "pre_approve_catalog", :data => { :path => pre_approve_home_catalog_path(catalog)}
        end
        span do
          ' | '
        end
        span do
          link_to 'Pendiente', pending_home_catalog_path(catalog), :method => :post
        end
      end
    end
    column "Descargas" do |catalog|
      span do
          link_to "Descargar", download_catalog_home_catalog_path(catalog)
      end
    end
  end

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs 'Editar Catálogo' do
      status = f.object.completed ? 'yes' : 'no'
      div :class => "status_tag #{status} completed_status_tag"  do
        f.object.completed ? "Sección completa" : "Hay campos incompletos";
      end
      f.input :fantasy_name, :label => "Nombre de fantasía"
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
      f.input :catalog_type, :label => "Tipo de catálogo", :as => :radio, :collection => [["", "Vertical"], ["", "Horizontal"]]
      f.input :description, :label => "Descripción catálogo (200 caracteres máx)", :input_html => { :maxlength => "200" }
      f.has_many :catalog_images, :heading => "Subir imágenes", :new_record => false, :html => { :enctype => "multipart/form-data" } do |ff|
        ff.input :priority, :label => "Tipo de imagen", :input_html => { :disabled => true, :value => "#{ff.object.priority.humanize}" }
        ff.input :attachment, :label => "Imagen".html_safe, :as => :file, :require => false, :hint => ff.object.attachment.present? ? image_tag(ff.object.attachment.url, :style => "width:200px") : content_tag(:span, "No hay imagen subida aún")
      end
    end
    f.actions do
      f.action(:submit)
    end
  end

  csv do
    column "Expositor" do |catalog|
      catalog.expositor.name
    end
    column "Nombre de fantasía" do |catalog|
      catalog.fantasy_name
    end
    column "Stand" do |catalog|
      catalog.stand_number
    end
    column "Tipo de catálogo" do |catalog|
      catalog.catalog_type
    end
    column "Email" do |catalog|
      catalog.email
    end
    column "Email adicional" do |catalog|
      catalog.aditional_email
    end
    column "Teléfono" do |catalog|
      catalog.phone_number
    end
    column "Teléfono adicional" do |catalog|
      catalog.aditional_phone_number
    end
    column "Web" do |catalog|
      catalog.website
    end
    column :twitter
    column :facebook
    column "Dirección" do |catalog|
      catalog.address
    end
    column "Provincia" do |catalog|
      catalog.province
    end
    column "Ciudad" do |catalog|
      catalog.city
    end
    column "Código postal" do |catalog|
      catalog.zip_code
    end
  end

  filter :completed, :label => "Completado", :collection => [["Si", true], ["No", false]]
  filter :state, :as => :select, :label => "Estado", :collection => [['Desaprobado', 0], ['Aprobado', 1], ['Pre aprobado', 2], ['Pendiente a aprobación', 3]]
  filter :stand_number, :label => "Nro stand"
  filter :email
  filter :twitter
  filter :facebook
  filter :address, :label => "Dirección"
end
