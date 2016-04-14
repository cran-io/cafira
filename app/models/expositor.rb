class Expositor < User
  has_many :expositions, :through => :exposition_expositors
  has_many :exposition_expositors, :dependent => :destroy
  has_many :credentials, :dependent => :destroy
  has_one :catalog, :dependent => :destroy
  has_one :aditional_service, :dependent => :destroy
  has_one :infrastructure, :dependent => :destroy

  #returns a Set of all expositors with uncompleted tasks and without much time to complete them
  def self.near_deadline(days_quantity)
    expositors = Set.new
    catalog_defaulters = self.joins(:catalog)
      .where("catalogs.completed = ?", false)
      .joins(:expositions)
      .where("expositions.deadline_catalogs >= ? AND expositions.deadline_catalogs <= ? AND expositions.active = ?", Date.today, Date.today + days_quantity.days, true)

    expositors.merge(catalog_defaulters) unless catalog_defaulters.empty?

    credential_defaulters = self.joins(:credentials)
      .where(:credentials => { :id => nil })
      .joins(:expositions)
      .where("expositions.deadline_credentials >= ? AND expositions.deadline_credentials <= ? AND expositions.active = ?", Date.today, Date.today + days_quantity.days, true) 
      
    expositors.merge(credential_defaulters) unless credential_defaulters.empty?

    aditional_services_defaulters = self.joins(:aditional_service)
      .where("aditional_services.completed =?", false)
      .joins(:expositions)
      .where("expositions.deadline_aditional_services >= ? AND expositions.deadline_aditional_services <= ? AND expositions.active = ? ", Date.today, Date.today + days_quantity.days, true)

    expositors.merge(aditional_services_defaulters) unless credential_defaulters.empty?

    infrastructure_defaulters = self.joins(:infrastructure)
      .where("infrastructures.completed =?", false)
      .joins(:expositions)
      .where("expositions.deadline_infrastructures >= ? AND expositions.deadline_infrastructures <= ? AND expositions.active = ?", Date.today, Date.today + days_quantity.days, true)
    
    expositors.merge(infrastructure_defaulters) unless infrastructure_defaulters.empty?
    expositors
  end

  def name_and_email
    (name || "") + " (" + email + ")"
  end

end
