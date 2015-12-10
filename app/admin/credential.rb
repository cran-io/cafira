ActiveAdmin.register Credential do
  belongs_to :expositor
  permit_params :name, :art, :armador, :es_expositor, :personal_stand, :foto_video, :fecha_alta
  menu :if => proc{ false }
  
  controller do
    def update
      update!{ home_expositor_credentials_path }
    end
    def create
      create!{ home_expositor_credentials_path }
    end
  end

  index :download_links => [:csv] do
    h2 "Credenciales"
    br
    column "Nombre", :name
    column "ART", :art, :class => "text-right"
    column "Armador", :armador, :class => 'text-right'
    column "Personal Stand", :personal_stand, :class => 'text-right'
    column "Expositor", :es_expositor, :class => 'text-right'
    column "Foto/Video", :foto_video, :class => 'text-right'
    column "Fecha de alta", :fecha_alta
    actions
  end  

  form do |f|
    f.semantic_errors
    f.inputs 'Credencial' do
      f.input :name, :label => "Nombre"
      f.input :art
      f.input :armador
      f.input :es_expositor, :label => "Expositor"
      f.input :personal_stand, :label => "Personal Stand"
      f.input :foto_video, :label => "Foto/Video"
      f.input :fecha_alta, :as => :datepicker
    end
    f.actions  
  end

  show do
    attributes_table do
      row "Nombre" do
        resource.name
      end
      row "ART" do
        resource.art? ? "Si" : "No"
      end
      row "Armador" do
        resource.armador? ? "Si" : "No"
      end
      row "Expositor" do
        resource.es_expositor? ? "Si" : "No"
      end
      row "Personal Stand" do
        resource.personal_stand? ? "Si" : "No"
      end
      row "Foto/Video" do
        resource.foto_video? ? "Si" : "No"
      end
      row "Fecha de alta" do
        resource.fecha_alta
      end
    end
  end

  filter :name, :label => "Nombre"
  filter :art, :label => "ART"
  filter :armador, :label => "Armador"
  filter :es_expositor, :label => "Expositor"
  filter :personal_stand, :label => "Personal Stand"
  filter :foto_video, :label => "Foto/Video"

end
