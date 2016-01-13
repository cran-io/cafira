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
end
