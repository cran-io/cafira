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
        status = 0
      elsif blueprint_file.attachment_file_name_changed?
        if blueprint_file.state == 0 || blueprint_file.state == 2
          blueprint_file.state = 3
        end
      else
        if blueprint_file.state == 0
          status = false
        end
      end
    end
    status = true if blueprint_files.where(:state => nil).where("attachment_file_name is not null").count == 2
    self.completed = status
    nil
  end

end
