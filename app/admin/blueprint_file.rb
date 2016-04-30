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
    #binding.pry
    # resource.update_attributes(:comment => params[:justification])
    current = 0
    if current_user.id == resource.id
      current = 1
    end
    resource.comments.build(:comment => 'comment2', :architect_id => current_user.id, who_created => current )
    resource.save
    #ExpositorMailer.blueprint_file_mail(resource.infrastructure.expositor, params[:justification], 'view_conversation').deliver_later(wait: 10)
    render :json => { :url => home_blueprint_files_path }
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
        msg = Array.new
        if !bp_file.comments.all[0].nil?
            #msg = {:comment => bp_file.comments.all[0].comment}.to_json
            bp_file.comments.all.each do |cmt|
            #  msg = {:comment => cmt.comment, :created_at => cmt.created_at, :architect_id => cmt.architect_id, :who_created => cmt.who_created}.to_json
              msg.push({:comment => cmt.comment, :created_at => cmt.created_at, :architect_id => cmt.architect_id, :who_created => cmt.who_created}.to_json)
            end
            conversation = {:comments => msg}.to_json
        end
        #binding.pry
        link_to 'Ver', 'javascript:void(0);', :method => :post, :class => "view_conversation", :data => { :path => view_conversation_home_blueprint_file_path(bp_file), :comments => conversation}#{:comment => bp_file.comment}.to_json, :data => { :comment => "bp_file.comment"}
      end
    end
  end

  filter :state, :as => :select, :label => "Estado", :collection => [['Desaprobado', 0], ['Aprobado', 1], ['Pre aprobado', 2], ['Pendiente a aprobación', 3]]
end
