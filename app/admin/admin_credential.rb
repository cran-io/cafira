ActiveAdmin.register Credential, :as => 'admin_credential' do
  permit_params :name, :art, :armador, :es_expositor, :personal_stand, :foto_video, :fecha_alta
  menu :if => proc{ current_user.type == 'AdminUser' }
  actions :all, :except => [:new, :create, :show]
  config.batch_actions = false

  index :download_links => [:csv] do
    h2 "Credenciales"
    column "Expositor" do |credential|
      credential.expositor.name_and_email
    end
    column "Nombre", :name
    column "ART", :art, :class => "text-right"
    column "Armador", :armador, :class => 'text-right'
    column "Personal Stand", :personal_stand, :class => 'text-right'
    column "Expositor", :es_expositor, :class => 'text-right'
    column "Foto/Video", :foto_video, :class => 'text-right'
    column "Fecha de alta", :fecha_alta
  end  

  csv do
    column "Expositor" do |credential|
      credential.expositor.name_and_email
    end
    column "Nombre" do |credential|
      credential.name
    end
    column "ART" do |credential|
      credential.art? ? "Si" : "No"
    end
    column "Armador" do |credential|
      credential.armador? ? "Si" : "No"
    end
    column "Expositor" do |credential|
      credential.es_expositor? ? "Si" : "No"
    end
    column "Personal Stand" do |credential|
      credential.personal_stand? ? "Si" : "No"
    end
    column "Foto/Video" do |credential|
      credential.foto_video? ? "Si" : "No"
    end
    column "Fecha de alta" do |credential|
      credential.fecha_alta
    end
  end

  filter :expositor_name, :label => "Nombre de expositor", :as => :string
  filter :name, :label => "Nombre"
  filter :art, :label => "ART", :collection => [["Si", true], ["No", false]]
  filter :armador, :label => "Armador", :collection => [["Si", true], ["No", false]]
  filter :es_expositor, :label => "Expositor", :collection => [["Si", true], ["No", false]]
  filter :personal_stand, :label => "Personal Stand", :collection => [["Si", true], ["No", false]]
  filter :foto_video, :label => "Foto/Video", :collection => [["Si", true], ["No", false]]

end
