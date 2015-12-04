ActiveAdmin.register Exposition, :as => "Exposiciones" do
  menu label: "Exposiciones"
  permit_params :ends_at, :initialized_at, :name, :active
  config.batch_actions = false

  index do
    h2 "Lista de exposiciones"
    br
    column "Nombre", :name
    column "Comenzada el", :initialized_at
    column "Termina el", :ends_at
    column "Activo", :active, :class => 'text-right'
    column "Acciones" do |exposition|
      span do 
        link_to 'Ver', {:controller => 'home/expositores', :action => 'index', :exposition_id => exposition.id}, :method => :get
      end
      span do 
        "|"
      end
      span do 
        link_to 'Editar', edit_home_exposicione_path(exposition), :method => :get
      end
      span do 
        "|"
      end
      span do
        link_to (exposition.active? ? 'Desactivar' : 'Activar'), activate_home_exposicione_path(exposition) , :method => :post
      end
    end
  end

  form do 
    table do
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
    redirect_to home_exposiciones_path, notice: "Exposición #{resource.name} actualizada satisfactoriamente."
  end

  #FILTERS
  filter :name, :label => "Nombre exposición"
  filter :initialized_at, :label => "Comenzada el"
  filter :ends_at, :label => "Termina el"
  filter :active, :label => "Activo"
end
