class Infrastructure < ActiveRecord::Base
  belongs_to :expositor
  has_many :blueprint_files, :dependent => :destroy
  accepts_nested_attributes_for :blueprint_files
  before_update :verify_fields

  private
  def verify_fields
    status = true
    blueprint_files.each do |blueprint_file|
      status = false if blueprint_file.attachment_file_name.nil?
  	end
    self.completed = status 
    nil
  end

end
