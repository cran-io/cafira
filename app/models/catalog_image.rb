class CatalogImage < ActiveRecord::Base
  belongs_to :catalog
  has_attached_file :attachment
  validates_attachment :attachment,
  	content_type: {
  		content_type: ["image/jpg", "image/jpeg", "image/png"]
	},
  	styles: {
  		medium: "300x300>",
  		thumb: "100x100>"
  	},
  	size: {
  		in: 0..5.megabytes
  	}

end
