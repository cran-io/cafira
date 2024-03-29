ActiveAdmin.register User do
  permit_params :email, :name, :type, :password, :password_confirmation
  menu priority: 10
  controller do
    def show
      redirect_to edit_home_user_path(resource)
    end
    def update
      update!{ home_users_path }
    end

    def create
      create! do
       home_users_path
      end
      ExpositorMailer.signup_mail(resource, params[:user][:password]).deliver_later(wait: 10) if Expositor.exists?(:id => resource.id)
    end
  end

  index :download_links => [:csv] do
    selectable_column
    column "E-mail", :email
    column "Nombre", :name
    column "Tipo" do |user|
      user.translated_type
    end
    column "Última sesión", :current_sign_in_at
    column "Creado el", :created_at
    column "Acciones" do |user|
      span do
        link_to 'Editar', edit_home_user_path(user), :method => :get
      end
      span do
        link_to 'Eliminar', home_user_path(user), :method => :delete, :data => { :confirm => '¿Estás seguro de eliminar este usuario?' }
      end
    end
  end

  form do |f|
    f.inputs (params[:action] == 'edit' ? "Editar usuario" : "Crear usuario") do
      f.input :name, :label => "Nombre"
      f.input :email, :label => "E-mail"
      if f.object.id.nil?
        f.input :type, :label => "Tipo de usuario", :as => :select, :include_blank => false, :allow_blank => false,
        :collection => [
          ["Administrador", "AdminUser"], 
          ["Expositor", "Expositor"], 
          ["Arquitecto", "Architect"],
          ["Organizador", "Organizer"],
          ["Diseñador", "Designer"]
        ]
      end
      f.input :password, :label => "Contraseña"
      f.input :password_confirmation, :label => "Confirmar contraseña"
    end
    f.actions
  end

  csv do
    column "E-mail" do |user|
      user.email
    end
    column "Nombre" do |user|
      user.name
    end
    column "Tipo" do |user|
      user.translated_type
    end
    column "Última sesión" do |user|
      user.current_sign_in_at
    end
    column "Creado el" do |user|
      user.created_at
    end
  end

  filter :email, :label => "E-mail"
  filter :type, :label => "Tipo de usuario"
end
