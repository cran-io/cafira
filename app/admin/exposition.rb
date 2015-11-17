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
      link_to 'Activar', activate_home_exposicione_path(exposition) , :method => :post 
    end
    actions
  end


  action_item :activate do
  end

  filter :name, :label => "Nombre exposición"
  filter :initialized_at, :label => "Comenzada el"
  filter :ends_at, :label => "Termina el"
  filter :active, :label => "Activo"

  member_action :activate, method: :post do
    if resource.active?
      resource.active = false
      resource.save
    else
      resource.active = true
      resource.save
    end
    redirect_to home_exposiciones_path, notice: "Exposición #{resource.name} safisfactoriamente."
  end

end
