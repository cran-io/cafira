class Catalog < ActiveRecord::Base
  belongs_to :expositor
  has_many :catalog_images, :dependent => :destroy
  accepts_nested_attributes_for :catalog_images
  before_update :verify_fields
  before_update :parse_phone_number

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
    headers = ['Nombre de fantasía', 'Nro stand', 'Website', 'Twitter', 'Facebook', 'Tel 1', 'Tel 2', 'Email', 'Email adicional', 'Dirección', 'Ciudad', 'Provincia', 'Código postal', 'Tipo de catálogo', 'Descripción']
    catalog_data  = [fantasy_name, stand_number, website, twitter, facebook, phone_number, aditional_phone_number, email, aditional_email, address, city, province, zip_code, catalog_type, description]
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
      if catalog_image.attachment_file_name.nil?
        status = false
      end
    end
    self.state = 3
    self.completed = status
    nil
  end

  private
  def parse_phone_number
    numbers = [self.phone_number, self.aditional_phone_number]
    numbers.reject! { |n| n.nil? || n.blank? || n.size < 5 }
    unless numbers.nil?
      numbers.map! do |p_number|
        country_area = '+54-'
        aux = 0

        province_l = self.province.downcase
        city_l = self.city.downcase

        if (city_l == 'la plata' || city_l == 'mar del plata' || city_l == 'bahia blanca' || city_l == 'bahía blanca' ||
           province_l == 'cordoba' || province_l == 'córdoba' || province_l =='cba' || province_l == 'santa fe' || province_l == 'jujuy' ||
           province_l == 'chaco' || province_l == 'chubut' || province_l == 'corrientes' || province_l == 'entre rios' || province_l == 'entre ríos' ||
           province_l == 'mendoza' || province_l == 'misiones' || province_l == 'neuquen' || province_l == 'neuquén' || province_l == 'neuquén' ||
           province_l == 'salta' || province_l == 'san juan' || province_l == 'santiago del estero' || province_l == 'tucuman' || province_l == 'neuquén' ||
           province_l == 'tucumán')
          digits = 7
        elsif(province_l == 'la pampa' || province_l == 'catamarca' || province_l == 'formosa' || province_l == 'río negro' || province_l == 'rio negro' ||
           province_l == 'san luis' || province_l == 'santa cruz' || province_l == 'tierra del fuego')
          digits = 6
        else
          digits = 8
        end


        if digits == 8
          number = /[0-9]{8}/.match(p_number[-8,8])
          if number.nil?
            number = /[0-9]{4}-[0-9]{4}/.match(p_number[-9,9])
            if !number.nil?
              aux = 1
              number = number.to_s
            else
              number = p_number[-8,8]
            end
          else
            number = p_number[-8,4] + '-' + p_number[-4,4]
          end

          # looks for the '15' prefix in the phone number
          prefix = p_number[-10-aux,2]
          if prefix == '15'
            aux += 2
          end


          # now it sees if how city area code was written if there is any
          city_area = /[0-9]{2}/.match(p_number[-10-aux,2])
          if city_area.nil?
              city_area = /[0-9]{2}-/.match(p_number[-11-aux,3])
              if city_area.nil?
                #assigns default city area code (C.A.B.A)
                city_area = '11-'
              else
                city_area = city_area.to_s
              end
          else
            city_area = city_area.to_s.concat('-')
          end

        end

        if digits == 7
          number = /[0-9]{7}/.match(p_number[-7,7])
          if number.nil?
            number = /[0-9]{3}-[0-9]{4}/.match(p_number[-8,8])
            if !number.nil?
              aux = 1
              number = number.to_s
            else
              number = p_number[-7,7]
            end
          else
            number = p_number[-7,3] + '-' + p_number[-4,4]
          end

          # looks for the '15' prefix in the phone number
          prefix = p_number[-9-aux,2]
          if prefix == '15'
            aux += 2
          end

          # now it sees if how city area code was written if there is any
          city_area = /[0-9]{3}/.match(p_number[-10-aux,3])
          if city_area.nil?
              city_area = /[0-9]{3}-/.match(p_number[-11-aux,4])
              if city_area.nil?
                city_area = ''
              else
                city_area = city_area.to_s
              end
          else
            city_area = city_area.to_s.concat('-')
          end

        end

        if digits == 6
          number = /[0-9]{6}/.match(p_number[-6,6])
          if number.nil?
            number = /[0-9]{2}-[0-9]{4}/.match(p_number[-7,7])
            if !number.nil?
              aux = 1
              number = number.to_s
            else
              number = p_number[-6,6]
            end
          else
            number = p_number[-6,2] + '-' + p_number[-4,4]
          end

          # looks for the '15' prefix in the phone number
          prefix = p_number[-8-aux,2]
          if prefix == '15'
            aux += 2
          end

          # now it sees if how city area code was written if there is any
          city_area = /[0-9]{4}/.match(p_number[-10-aux,4])
          if city_area.nil?
              city_area = /[0-9]{4}-/.match(p_number[-11-aux,5])
              if city_area.nil?
                city_area = ''
              else
                city_area = city_area.to_s
              end
          else
            city_area = city_area.to_s.concat('-')
          end
        end


        if (city_area[0] == '4') && (p_number[2] != '-' || p_number[3] != '-')
          city_area = city_area[1,3]
        end

        if city_area[0] == '0'
          city_area = city_area[1,3]
        end

        formatted_number = country_area + city_area + number

        p_number = formatted_number
      end
    self.phone_number = numbers[0]
    self.aditional_phone_number = numbers[1]
    end
    nil
  end
end
