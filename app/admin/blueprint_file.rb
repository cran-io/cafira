ActiveAdmin.register BlueprintFile do
  actions :all, :except => [:new, :create]

  config.batch_actions = false

  batch_action :destroy, false

  batch_action :approve_blueprint_files do |ids|
    BlueprintFile.where(:id => ids).update_all(:state => true)
    redirect_to home_blueprint_files_path
  end

  batch_action :disapprove_blueprint_files do |ids|
    ids.each do |id|
      bp_file = BlueprintFile.fin(did)
      bp_file.update_attribute(:state, false)
      bp_file.infrastructure.update_attribute(:completed, false)
    end
    redirect_to home_blueprint_files_path
  end

  batch_action :pending_blueprint_files do |ids|
    BlueprintFile.where(:id => ids).update_all(:state => nil)
    redirect_to home_blueprint_files_path
  end

  member_action :approve, method: :post do
    resource.update_attributes(:state => true, :comment => nil)
    redirect_to home_blueprint_files_path
   end

  member_action :disapprove, method: :post do
    resource.update_attributes(:state => false, :comment => params[:justification])
    resource.infrastructure.update_attribute(:completed, false)
    ExpositorMailer.dissaproved_blueprint_file(resource.infrastructure.expositor, params[:justification]).deliver
    render :json => { :url => home_blueprint_files_path }
  end

  member_action :pending, method: :post do
    resource.update_attributes(:state => nil, :comment => nil)
    redirect_to home_blueprint_files_path
  end


  index do 
    selectable_column
    column "Plano" do |bp_file|
      link_to((bp_file.attachment_file_name || ""), bp_file.attachment.url)
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
    column "Expositor" do |bp_file|
      bp_file.infrastructure.expositor.name_and_email
    end
    column "Último upload", :attachment_updated_at
    column "Acciones" do |bp_file|
      span do
        link_to 'Aprobar', approve_home_blueprint_file_path(bp_file), :method => :post
      end
      span do 
        ' | '
      end
      span do
        link_to 'Desaprobar', 'javascript:void(0);', :method => :post, :class => "dissaprove_blueprint_file", :data => { :path => disapprove_home_blueprint_file_path(bp_file)}
      end
      span do 
        ' | '
      end
      span do
        link_to 'Poner pendiente', pending_home_blueprint_file_path(bp_file), :method => :post
      end
    end
  end

  filter :bp_state_eq, :as => :select, :label => "Estado", :collection => [['Aprobado', 2], ['Desaprobado', 1], ['Pendiente a aprobación', 0]]
end
