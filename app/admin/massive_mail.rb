ActiveAdmin.register MassiveMail do
  config.filters = false
  config.batch_actions = false
  permit_params :campaign, :subject, :body, :attachment, :attachment_file_name, :attachment_content_type, :attachment_file_size, :attachment_updated_at, :id

  controller do 
    def update
      update! do
        flash[:message] = "Mail actualizado correctamente."
        home_massive_mails_path 
      end
    end
    
    def create
      list_id = 'c6a14e89c9';
      recipients = {
        list_id: list_id,
        :segment_text => ""
      }
      settings = {
        :subject_line => params[:massive_mail][:subject],
        :title => "Cafira#{ MassiveMail.last ? (MassiveMail.last.id + 1) : '1' }",
        :from_name => "Cafira",
        :reply_to => "jota@cran.io",
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
        body = { 
          :template => {
            :id => 53273,
            :sections => {
              "eventmessage" => params[:massive_mail][:body]
            }
          }
        }
        #why am i doing this instead of setting the template info on create? because mailchimp API is bullshit! and doesnt allow me to do it :(. This seems to work fine :)
        GIBBON.campaigns(campaign["id"]).content.upsert(:body => body)
        create! do
          flash[:message] = "Mail creado correctamente." 
          home_massive_mails_path
        end
      rescue Gibbon::MailChimpError => e
        flash[:message] = "No se pudo crear el mail: #{e.message} - #{e.raw_body}"
      end
    end
  end
  
  member_action :massive_send, :method => :post do
    begin
      GIBBON.campaigns(resource.campaign).actions.send.create
      flash[:message] = "Mails enviados satisfactoriamente."
    rescue Gibbon::MailChimpError => e
      flash[:message] = "Hubo un error al envíar el e-mail a la lista."
    end
    redirect_to home_massive_mails_path
  end

  index :download_links => false do
    column "Asunto", :subject
    column "Cuerpo", :body do |massive_mail|
      "#{massive_mail.body[0..200]}..."
    end
    column "Archivo adjunto" do |massive_mail|
      massive_mail.attachment.present? ? link_to((massive_mail.attachment_file_name || ""), massive_mail.attachment.url) : 'No hay adjunto'
    end
    column "Acciones" do |massive_mail|
      span do
        link_to 'Editar',  edit_home_massive_mail_path(massive_mail), :method => :get
      end
      span do 
        ' | '
      end
      span do
        link_to 'Eliminar', home_massive_mail_path(massive_mail), :method => :delete
      end
      span do 
        ' | '
      end
      span do
        link_to 'Enviar', massive_send_home_massive_mail_path(massive_mail) , :method => :post, :data => { :confirm => "Esto hará que se envíe este mail de manera masiva a toda su lista de contactos. ¿Está seguro?" }
      end
    end
  end
  
  form do |f|
    f.inputs "Mail masivo" do
      f.input :subject, :label => "Asunto"
      f.input :attachment, :label => "Archivo adjunto", :as => :file, :require => false, :hint => f.object.attachment.present? ? image_tag(f.object.attachment.url, :style => "width:200px") : content_tag(:span, "No hay imagen subida aún")
      f.input :body, :label => "Cuerpo"
    end
    f.actions
  end
end
