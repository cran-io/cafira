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

end
