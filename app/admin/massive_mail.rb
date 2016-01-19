ActiveAdmin.register MassiveMail do
  config.filters = false
  config.batch_actions = false
  permit_params :campaign, :subject, :body, :attachment, :attachment_file_name, :attachment_content_type, :attachment_file_size, :attachment_updated_at, :id
  menu priority: 10
  controller do 

    def create
      list_id = '22bd0f58af';
      recipients = {
        list_id: list_id,
        :segment_text => ""
      }
      settings = {
        :subject_line => params[:massive_mail][:subject],
        :title => "Cafira#{ MassiveMail.last ? (MassiveMail.last.id + 1) : '1' }",
        :from_name => "Cafira",
        :reply_to => "info1@cafira.com",
        :to_name => "*|FNAME|*"
      }

      body = {
        :type => "regular",
        :recipients => recipients,
        :settings => settings,
      }
      
      begin
        campaign = GIBBON.campaigns.create(body: body)
        params[:massive_mail][:campaign] = campaign["id"]
        create! do
          image = resource.attachment.present? ? "<img src='http://intranetcafira.com#{resource.attachment.url}'>" : ""
          body = { 
            :template => {
              :id => 50381,
              :sections => {
                "body_text" => params[:massive_mail][:body],
                "image" => image
              }
            }
          }

          #why am i doing this instead of setting the template info on create? because mailchimp API is bullshit (or maybe gibbon)! and doesnt allow me to do it :(. This seems to work fine :)
          begin
            GIBBON.campaigns(campaign["id"]).content.upsert(:body => body)
            flash[:message] = "Mail creado correctamente." 
          rescue
            flash[:message] = "Creado correctamente, pero no updateado correctamente."  
          end
          home_massive_mails_path
        end
      rescue Gibbon::MailChimpError => e
        flash[:message] = "No se pudo crear el mail: #{e.message} - #{e.raw_body}"
      end
    end

    def update
      update! do
        image = resource.attachment.present? ? "<img src='http://intranetcafira.com/#{resource.attachment.url}'>" : ""
        body = { 
          :template => {
            :id => 53273,
            :sections => {
              "body_text" => params[:massive_mail][:body],
              "image" => image
            }
          }
        }
        begin
          GIBBON.campaigns(resource.campaign).content.upsert(:body => body) 
          flash[:message] = "Mail actualizado correctamente."
        rescue
          flash[:message] = "Hubo un error al actualizar el mail."  
        end
        home_massive_mails_path 
      end
    end

    def destroy
      begin
        resource.delete
        GIBBON.campaigns(resource.campaign).delay(run_at: 2.days.from_now).delete
        flash[:message] = "Mail eliminado correctamente."
      rescue
        flash[:message] = "Hubo un error al eliminar el mail."  
      end
      redirect_to home_massive_mails_path
    end

  end
  
  member_action :massive_send, :method => :post do
    begin
      GIBBON.campaigns(resource.campaign).actions.send.create
      resource.update_attribute(:sent, true)
      flash[:message] = "Mails enviados satisfactoriamente."
    rescue Gibbon::MailChimpError => e
      flash[:message] = "Hubo un error al envíar el e-mail a la lista."
    end
    redirect_to home_massive_mails_path
  end

  index :download_links => false do
    column "Asunto", :subject
    column "Cuerpo", :body do |massive_mail|
      "#{massive_mail.body}".html_safe
    end
    column "Archivo adjunto" do |massive_mail|
      massive_mail.attachment.present? ? link_to((massive_mail.attachment_file_name || ""), massive_mail.attachment.url) : 'No hay adjunto'
    end
    column "Acciones" do |massive_mail|
      if not massive_mail.sent?
        span do
          link_to 'Editar',  edit_home_massive_mail_path(massive_mail), :method => :get
        end
        span do 
          ' | '
        end
        span do
          link_to 'Eliminar', home_massive_mail_path(massive_mail), :method => :delete, :data => {:confirm => "¿Está seguro que desea eliminar este email?"}
        end
        span do 
          ' | '
        end
        span do
          link_to 'Enviar', massive_send_home_massive_mail_path(massive_mail) , :method => :post, :data => { :confirm => "Esto hará que se envíe este mail de manera masiva a toda su lista de contactos. ¿Está seguro?" }
        end
      else
        span :class => "sent-mail" do
          ' Mail enviado ☑'
        end
        span do
          ' | '
        end
        span do
          link_to 'Eliminar', home_massive_mail_path(massive_mail), :method => :delete, :data => {:confirm => "¿Está seguro que desea eliminar este email?"}
        end
      end
    end
  end
  
  form do |f|
    f.inputs "Mail masivo" do
      f.input :subject, :label => "Asunto"
      f.input :attachment, :label => "Archivo adjunto", :as => :file, :require => false, :hint => f.object.attachment.present? ? image_tag(f.object.attachment.url, :style => "width:200px") : content_tag(:span, "No hay imagen subida aún")
      f.input :body, :label => "Cuerpo", :input_html => { :class => "ckeditor" }
    end
    f.actions
  end
end
