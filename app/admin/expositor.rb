ActiveAdmin.register Expositor do
  permit_params :name, :email, :cuit
  menu false
  actions :all, :except => [:new, :create, :destroy]
  config.clear_action_items!
  batch_action :destroy, false

  batch_action :delete_from_exposition, if: proc{ params[:type] != 'all_expositors' } do |ids|
    ids.each do |id|
      exposition_expositors = ExpositionExpositor.where(:exposition_id => Rails.cache.read(:exposition_id), :expositor_id => id)
      exposition_expositors.delete_all
    end
    redirect_to home_expositors_path(:exposition_id => Rails.cache.read(:exposition_id))
  end

  batch_action :add_expositors_to_exposition, if: proc{ params[:type] == 'all_expositors' } do |ids|
    if Rails.cache.read(:exposition_id)
      exposition_id = Rails.cache.read(:exposition_id)
      ids.each do |id|
        ExpositionExpositor.create(:exposition_id => exposition_id, :expositor_id => id) if ExpositionExpositor.find_by_exposition_id_and_expositor_id(exposition_id, id).nil?
      end
    end
    redirect_to home_expositors_path(:exposition_id => Rails.cache.read(:exposition_id))
  end

  action_item :only => :index, if: proc { params[:type].nil? } do
    link_to 'Agregar expositores a esta exposición', home_expositors_path(:type => 'all_expositors', :exposition_id => params[:exposition_id])
  end

  action_item :only => :index, if: proc{ params[:type] == 'all_expositors' } do
    link_to 'Ver expositores de esta exposición', home_expositors_path(:exposition_id => params[:exposition_id])
  end

  controller do
    def index
      if params[:exposition_id]
        Rails.cache.write('exposition_id', params[:exposition_id])
        @exposition_id = params[:exposition_id]
        index!
      else
        redirect_to home_expositions_path
      end
    end

    def show
      redirect_to edit_home_expositor_path
    end

    def update
      update! do
        flash[:message] = "Datos del expositor actualizados correctamente."
        edit_home_expositor_path(resource)
      end
    end

    def edit
      edit! do
        exposition = nil
        @exposition_active = false
        if(current_user.type == 'Expositor')
          if !current_user.expositions.empty? && current_user.expositions.last.active
            exposition = current_user.expositions.last.id
            @exposition_active = true
            exposition = Exposition.find(exposition)
            @manual_url = exposition.exposition_files.find_by_file_type("manual").attachment.url
            @plan_url   = exposition.exposition_files.find_by_file_type("plan_tiempos").attachment.url
            @bylaw_url  = exposition.exposition_files.find_by_file_type("reglamento").attachment.url
          end
        end
      end
    end

    def scoped_collection
      if params[:exposition_id]
        if params[:type] == 'all_expositors'
          expositors_ids = ExpositionExpositor.where(:exposition_id => params[:exposition_id]).map(&:expositor_id)
          @expositors = Expositor.where.not(:id => expositors_ids)
        else
          @expositors = Exposition.find(params[:exposition_id]).expositors
        end
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


  sidebar "Descargas", :priority => 1, :only => [:show, :edit] do
    if exposition_active
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
    else
      "No esta en una exposicion activa"
    end
  end


  index :download_links => false do
    if exposition_id
      h2 "Expositores en \"" + Exposition.find(params[:exposition_id]).name + "\""
      selectable_column
    else
      h2 "Expositores"
    end
    column "Nombre", :name
    column "Cuit", :cuit
    column "E-mail", :email
    column "Acciones" do |expositor|
      span do
        link_to "Editar", edit_home_expositor_path(expositor)
      end
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs 'Expositor' do
      f.input :name, :label => "Nombre", :input_html => { :disabled => true }
      f.input :email, :label => "E-mail", :input_html => { :disabled => true }
      f.input :cuit, :label => "Cuit"
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
  filter :email, :label => "E-mail"

end
