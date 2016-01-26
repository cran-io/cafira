namespace :models do
  task :add_aditional_catalog_images => :environment do
    Expositor.all.each do |expositor|
      if expositor.aditional_service.catalogo_extra? && !expositor.catalog.catalog_images.where("priority ILIKE ?", "%_adicional").any?
        expositor.catalog.update_columns(:completed => false)
        ['primaria_adicional', 'secundaria_adicional', 'secundaria_adicional', 'secundaria_adicional'].each do |priority|
          expositor.catalog.catalog_images << CatalogImage.new( :priority => priority )
        end
      end
    end
  end
  task :add_catalog_image_status => :environment do
    CatalogImage.all.each do |catalog_image|
      if catalog_image.attachment.present?
        dimensions = Paperclip::Geometry.from_file(catalog_image.attachment)
        catalog_image.valid_image = !(dimensions.width < 600 || dimensions.height < 600)
        catalog_image.save
        p "#{dimensions} #{catalog_image.valid_image}"
      end
    end
  end
  task :set_completed_catalogs => :environment do
    Catalog.all.each do |catalog|
      status = true
      catalog.catalog_images.each do |catalog_image|
        if catalog_image.attachment_file_name.nil? || AttachmentDimensions.not_valid_dimensions(catalog_image.attachment)
          status = false
        end
      end
      catalog.update_columns(:completed => status)
      p "catalog class: #{status}"
    end
  end
end

module AttachmentDimensions
  def not_valid_dimensions image
    dimensions = Paperclip::Geometry.from_file(image)
    true if dimensions.width < 600 || dimensions.height < 600
  end
  module_function :not_valid_dimensions
end
