ActiveAdmin.register BlueprintFile do
  actions :all, :except => [:new, :create]
  permit_params :comments#, :comments_attributes => [:comment, :blueprint_file_id, :architect_id]
  menu :if  => proc {current_user.type != 'Expositor' && (current_user.type == 'Architect' || current_user.type == 'AdminUser') }
  menu priority: 5
  config.batch_actions = false

  batch_action :destroy, false

  batch_action :approve_blueprint_files do |ids|
    BlueprintFile.where(:id => ids).update_all(:state => 1)
    redirect_to home_blueprint_files_path
  end

  batch_action :disapprove_blueprint_files do |ids|
    ids.each do |id|
      bp_file = BlueprintFile.fin(did)
      bp_file.update_attribute(:state, 0)
      bp_file.infrastructure.update_attribute(:completed, 0)
    end
    redirect_to home_blueprint_files_path
  end

  batch_action :pending_blueprint_files do |ids|
    BlueprintFile.where(:id => ids).update_all(:state => 3)
    redirect_to home_blueprint_files_path
  end

  member_action :pending, method: :post do
    resource.update_attributes(:state => 3, :comment => nil)
    redirect_to home_blueprint_files_path
  end

  member_action :approve, method: :post do
    resource.update_attributes(:state => 1, :comment => params[:justification])
    ExpositorMailer.blueprint_file_mail(resource.infrastructure.expositor, params[:justification], 'approved').deliver_later(wait: 10)
    render :json => { :url => home_blueprint_files_path }
  end

  member_action :disapprove, method: :post do
    resource.update_attributes(:state => 0, :comment => params[:justification])
    resource.infrastructure.update_attribute(:completed, false)
    ExpositorMailer.blueprint_file_mail(resource.infrastructure.expositor, params[:justification], 'disapproved').deliver_later(wait: 10)
    render :json => { :url => home_blueprint_files_path }
  end


  member_action :pre_approve, method: :post do
    resource.update_attributes(:state => 2, :comment => params[:justification])
    ExpositorMailer.blueprint_file_mail(resource.infrastructure.expositor, params[:justification], 'pre_approved').deliver_later(wait: 10)
    render :json => { :url => home_blueprint_files_path }
  end

  member_action :view_conversation, method: :post do
    resource.comments.build(:comment => params[:comment], :architect_id => current_user.id, :created_by => 'architect' )
    resource.save
    ExpositorMailer.blueprint_file_conversation_mail(resource.infrastructure.expositor, params[:comment], 'arquitecto', resource.attachment_file_name).deliver_later(wait: 10)
  end

  index :download_links => false do
    selectable_column
    column "Plano", :class => "empty-label" do |bp_file|
      bp_file.attachment.present? ? link_to((bp_file.attachment_file_name || ""), bp_file.attachment.url) : 'No subido aún'
    end
    column "Estado", :state do |bp_file|
      case bp_file.state
      when 0
        status_tag 'Desaprobado', :red
      when 1
        status_tag 'Aprobado', :yes
      when 2
        status_tag 'Pre aprobación', :grey
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
        link_to 'Aprobar', 'javascript:void(0);', :method => :post, :class => "approve_blueprint_file", :data => { :path => approve_home_blueprint_file_path(bp_file)}
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
        link_to 'Pre aprobar', 'javascript:void(0);', :method => :post, :class => "pre_approve_blueprint_file", :data => { :path => pre_approve_home_blueprint_file_path(bp_file)}
      end
      span do
        ' | '
      end
      span do
        link_to 'Pendiente', pending_home_blueprint_file_path(bp_file), :method => :post
      end
    end
    column "Conversación" do |bp_file|
      span do
        link_to 'Ver', 'javascript:void(0);', :method => :post, :class => "view_conversation", :data => { :path => view_conversation_home_blueprint_file_path(bp_file), :comments => bp_file.comments_to_json('architect')}
      end
    end
  end

  filter :state, :as => :select, :label => "Estado", :collection => [['Desaprobado', 0], ['Aprobado', 1], ['Pre aprobado', 2], ['Pendiente a aprobación', 3]]
end
