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
    [:twitter, :facebook, :description, :phone_number, :aditional_phone_number, :email, :aditional_email, :website, :address, :city, :province, :zip_code].each do |attribute|
      status = false if self[attribute].nil? || self[attribute].empty?
    end
    self.completed = status
    nil
  end

end
