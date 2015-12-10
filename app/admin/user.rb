ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation
  controller do
    def show
      redirect_to edit_home_user_path(resource)
    end
    def update
      update!{ home_users_path }
    end
    def create
      create!{ home_users_path }
    end
  end
  index do
    selectable_column
    column "E-mail", :email
    column "Tipo", :type
    column "Última sesión", :current_sign_in_at
    column "Creado el", :created_at
    column "Acciones" do |exposition|
      span do 
        link_to 'Editar', edit_home_user_path(exposition), :method => :get
      end
      span do 
        link_to 'Eliminar', home_user_path(exposition), :method => :delete, :data => { :confirm => '¿Estás seguro de eliminar este usuario?' }
      end
    end
  end

  filter :email, :label => "E-mail"
  filter :type, :label => "Tipo de usuario"
  form do |f|
    f.inputs "Admin Details" do
      f.input :email, :label => "E-mail"
      f.input :password, :label => "Contraseña"
      f.input :password_confirmation, :label => "Confirmar contraseña"
    end
    f.actions
  end

end
