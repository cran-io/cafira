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
        zip.add(index.to_s + catalog_image.attachment_file_name, catalog_image.attachment.path)
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
