class Catalog < ActiveRecord::Base
  belongs_to :expositor
  has_many :catalog_images, :dependent => :destroy
  accepts_nested_attributes_for :catalog_images
  before_update :verify_fields

  def download_catalog
    filename = 'datos_catalogo.zip'
    temp_file = Tempfile.new(filename)
    catalog_data = generate_xslx
    Zip::OutputStream.open(temp_file) { |zos| }
    Zip::File.open(temp_file.path, Zip::File::CREATE) do |zip|
      zip.add('datos_catalogo.xlsx', catalog_data.path)
      catalog_images.each_with_index do |catalog_image, index|
        zip.add("#{index}_#{catalog_image.priority}_#{catalog_image.attachment_file_name}" , catalog_image.attachment.path) if catalog_image.attachment.present?
      end
    end
    temp_file
  end

  private
  
  def generate_xslx
    headers = ['Nro stand', 'Website', 'Twitter', 'Facebook', 'Tel 1', 'Tel 2', 'Email', 'Email adicional', 'Dirección', 'Ciudad', 'Provincia', 'Código postal']
    catalog_data  = [ stand_number, website, twitter, facebook, phone_number, aditional_phone_number, email, aditional_email, address, city, province, zip_code]

    package = Axlsx::Package.new
    package.workbook.add_worksheet(:name => "Catálogo") do |sheet|
      sheet.add_row headers        
      sheet.add_row catalog_data 
    end
    tmpfile = Tempfile.new('catalogo')
    package.serialize(tmpfile)
    tmpfile
  end
  
  private
  def verify_fields
    status = true
    catalog_images.each do |catalog_image|
      catalog_image.valid_image = true
      if catalog_image.attachment_file_name.nil?
        status = false
      end
      if catalog_image.attachment_file_name_changed?
        if !catalog_image.attachment.queued_for_write[:original].nil? && not_valid_dimensions(catalog_image.attachment.queued_for_write[:original])
          status = false
          catalog_image.valid_image = false
        end
      else
        if !catalog_image.attachment_file_name.nil? && not_valid_dimensions(catalog_image.attachment)
          status = false
          catalog_image.valid_image = false
        end
      end
      catalog_image.save
    end
    self.completed = status
    nil
  end

  def not_valid_dimensions image
    dimensions = Paperclip::Geometry.from_file(image)
    true if dimensions.width < 600 || dimensions.height < 600
  end

end
