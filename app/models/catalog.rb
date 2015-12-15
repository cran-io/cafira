class Catalog < ActiveRecord::Base
  belongs_to :expositor
  has_many :catalog_images, :dependent => :destroy
  accepts_nested_attributes_for :catalog_images
  before_update :verify_fields

  private
  def verify_fields
    status = true
    catalog_images.each do |catalog_image|
      status = false if catalog_image.attachment_file_name.nil?
  	end
  	status = false if (self.stand_number.nil? || self.twitter.nil? || self.facebook.nil?) || (self.stand_number.empty? || self.twitter.empty? || self.facebook.empty?)
    self.completed = status
    nil
  end

end
