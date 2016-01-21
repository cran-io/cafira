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
end
