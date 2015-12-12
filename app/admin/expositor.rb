ActiveAdmin.register Expositor do
  menu false
  permit_params :name, :email, :cuit, :password, :password_confirmation

  controller do
    def index
      Rails.cache.write('exposition_id', params[:exposition_id])
      index!
    end

    def create
      create! do
        ExpositionExpositor.create(:exposition_id => Rails.cache.read(:exposition_id), :expositor_id => resource.id)
        resource.aditional_service = AditionalService.new
        resource.infrastructure    = Infrastructure.new
        resource.catalog           = Catalog.new
        4.times do |i|
          resource.catalog.catalog_images << CatalogImage.new( :priority => (i.zero? ? 'principal' : 'secundaria') )
        end
        2.times do |i|
          resource.infrastructure.blueprint_files << BlueprintFile.new
        end
        home_expositors_path(:exposition_id => Rails.cache.read(:exposition_id))
      end
      #if it was correctly created it sends a signup mail
      #ExpositorMailer.signup_mail(resource,params[:expositor][:password]).deliver if Expositor.exists?(:id => resource.id)
    end

    def scoped_collection
      if params[:exposition_id]
        @expositors = Exposition.find(params[:exposition_id]).expositors
      else
        @expositors = Expositor.all
      end
    end
  end

  sidebar "Acciones del expositor", :priority => 0, :only => [:show, :edit] do
    ul do
      li do
        span do
          link_to 'Datos del expositor',  edit_home_expositor_path(resource), :method => :get
        end
      end
      li do
        span do
          link_to 'Catálogo', edit_home_catalogo_path(resource), :method => :get
        end
      end
      li do
        span do
          link_to 'Credenciales',  home_expositor_credentials_path(resource), :method => :get
        end
      end
      li do
        span do
          link_to 'Servicios Adicionales', edit_home_services_path(resource), :method => :get
        end
      end
      li do
        span do
          link_to 'Infraestructura', edit_home_infrastruct_path(resource), :method => :get
        end
      end
    end
  end

  index :download_links => [:csv] do
    if params[:exposition_id]
      h2 "Expositors en \"" + Exposition.find(params[:exposition_id]).name + "\""
    else
      h2 "Expositors"
    end
    column "Nombre", :name
    column "Cuit", :cuit
    column "E-mail", :email
    actions
  end

  form do |f|
    f.semantic_errors
    f.inputs 'Expositor' do
      f.input :name, :label => "Nombre"
      f.input :email, :label => "E-mail"
      f.input :cuit, :label => "Cuit"
      f.input :password, :label => "Contraseña"
      f.input :password_confirmation, :label => "Confirmación contraseña"
    end
    f.actions do
      f.action(:submit)
    end
  end

  show do
    attributes_table do
      row "Nombre" do
        resource.name
      end
      row "E-mail" do
        resource.email
      end
      row "Cuit" do
        resource.cuit
      end
    end
  end

  filter :name, :label => "Nombre"
  filter :cuit, :label => "Cuit"
  filter :email, :label => "Email"

end
