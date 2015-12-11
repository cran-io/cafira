class Catalog < ActiveRecord::Base
  belongs_to :expositor
  has_many :catalog_images
  accepts_nested_attributes_for :catalog_images
end
