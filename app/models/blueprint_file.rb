class BlueprintFile < ActiveRecord::Base
  has_many :comments, :dependent => :destroy
  accepts_nested_attributes_for :comments
  belongs_to :infrastructure
  has_attached_file :attachment
  validates_attachment :attachment,
    content_type: {
     content_type: ['image/jpg', 'image/jpeg', 'image/png', 'application/pdf']
    },
    size: {
     in: 0..5.megabytes
    }

  def comments_to_json(current_user_type = 'expositor')
    bp_file_comments = Array.new
    conversation = 'empty'
    if !self.comments.all[0].nil?
        self.comments.all.each do |cmt|
          if cmt.created_by == 'expositor'
            user_type = 'expositor'
            user_id = Infrastructure.find(BlueprintFile.find(cmt.blueprint_file_id).infrastructure_id).expositor_id
          else
            user_type = 'architect'
            user_id = cmt.architect_id
          end
          name = User.find(user_id).name
          date = cmt.created_at.strftime("%d/%m/%y a las: %H:%M")
          bp_file_comments.push({:comment => cmt.comment, :created_at => date, :user_name => name, :architect_id => cmt.architect_id, :created_by => user_type, :reason => cmt.reason}.to_json)
        end
        conversation = {:comments => bp_file_comments, :id => self.id, :user_type => current_user_type}.to_json
    end
    return conversation
  end

end
