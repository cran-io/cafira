class Infrastructure < ActiveRecord::Base
  belongs_to :expositor
  has_many :blueprint_files, :dependent => :destroy
  accepts_nested_attributes_for :blueprint_files
  before_update :verify_fields

  def download_infrastructure
    filename = 'datos_infraestructura.zip'
    temp_file = Tempfile.new(filename)
    catalog_data = generate_xslx
    Zip::OutputStream.open(temp_file) { |zos| }
    Zip::File.open(temp_file.path, Zip::File::CREATE) do |zip|
      zip.add('datos_infraestructura.xlsx', catalog_data.path)
      blueprint_files.each_with_index do |bp_file, index|
        zip.add("#{bp_file.attachment_file_name}_#{index + 1}" , bp_file.attachment.path) if bp_file.attachment.present?
      end
    end
    temp_file
  end
  private

  def generate_xslx
    headers = ['Tarima', 'Paneles', 'Alfombra', 'Alfombra Tipo']
    infrastructure_data  = [
      (tarima == true ? 'SI' : 'NO'), 
      (paneles == true ? 'SI' : 'NO'),
      (alfombra == true ? 'SI' : 'NO'),
      (alfombra_tipo.nil? ? '-' : alfombra_tipo.camelize)
    ]

    package = Axlsx::Package.new
    package.workbook.add_worksheet(:name => "Infraestructura") do |sheet|
      sheet.add_row headers        
      sheet.add_row infrastructure_data 
    end
    tmpfile = Tempfile.new('infraestructura')
    package.serialize(tmpfile)
    tmpfile
  end

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
