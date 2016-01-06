class CatalogImage < ActiveRecord::Base
  belongs_to :catalog
  has_attached_file :attachment
  validates_attachment :attachment,
  	content_type: {
  		content_type: ["image/jpg", "image/jpeg", "image/png"]
	},
  	size: {
  		in: 0..5.megabytes
  	}

end
