class ExpositionFile < ActiveRecord::Base
  belongs_to :exposition
  has_attached_file :attachment
  validates_attachment_content_type :attachment, :content_type => ['application/zip', 'application/x-zip', 'application/x-zip-compressed', 'application/pdf', 'application/x-pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document']
  validates_attachment_size :attachment, :less_than => 5.megabytes
  validates_attachment_presence :attachment
end
