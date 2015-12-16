ActiveAdmin.register BlueprintFile do
  
  batch_action :destroy, false
  
  batch_action :approve_blueprint_files do |ids|
    BlueprintFile.where(:id => ids).update_all(:state => true)
    redirect_to home_blueprint_files_path
  end

  batch_action :disapprove_blueprint_files do |ids|
    ids.each do |id|
      bp_file = BlueprintFile.find(id)
      bp_file.update_attribute(:state, false)
      bp_file.infrastructure.update_attribute(:completed, false)
    end
    redirect_to home_blueprint_files_path
  end

  batch_action :pending_blueprint_files do |ids|
      BlueprintFile.where(:id => ids).update_all(:state => nil)
      redirect_to home_blueprint_files_path
  end


  index do 
    selectable_column
    column "Expositor" do |bp_file|
      bp_file.infrastructure.expositor.name_and_email
    end
    column "Estado", :state do |bp_file|
      case bp_file.state
      when true
        status_tag 'Aprobado', :yes
      when false
        status_tag 'Desaprobado', :red
      else
        status_tag 'Pendiente', :orange
      end
    end
    column "Nombre de archivo", :attachment_file_name 
    column "Último upload", :attachment_updated_at
    column "Acciones" do |bp_file|
      span do
        'Aprobar'
      end
      span do 
        ' | '
      end
      span do
        'Desaprobar'
      end
      span do 
        ' | '
      end
      span do
        'Poner pendiente'
      end
    end
  end
  filter :bp_state_eq, :as => :select, :label => "Estado", :collection => [['Aprobado', 2], ['Desaprobado', 1], ['Pendiente a aprobación', 0]]
end
