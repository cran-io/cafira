class Catalog < ActiveRecord::Base
  belongs_to :expositor
  has_many :catalog_images
end
