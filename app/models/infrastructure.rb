class Infrastructure < ActiveRecord::Base
  belongs_to :expositor
  has_many :blueprint_files, :dependent => :destroy
  accepts_nested_attributes_for :blueprint_files
  before_update :verify_fields

  private
  def verify_fields
    status = true
    blueprint_files.each do |blueprint_file|
      if blueprint_file.attachment_file_name.nil?
        status = false 
      elsif blueprint_file.attachment_file_name_changed?
        if blueprint_file.state == false
          blueprint_file.state = nil
        end
      else
        if blueprint_file.state == false
          status = false
        end
      end
    end
    status = true if blueprint_files.where(:state => nil).count == 2
    self.completed = status
    nil
  end

end
