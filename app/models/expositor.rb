class Expositor < User
  has_many :expositions, :through => :exposition_expositors
  has_many :exposition_expositors, :dependent => :destroy
  has_many :credentials, :dependent => :destroy
  has_one :catalog, :dependent => :destroy
  has_one :aditional_service, :dependent => :destroy
  has_one :infrastructure, :dependent => :destroy

  def self.near_deadline
    aSetofExpositors = Set.new
    aSetofExpositors.merge(self.joins(:expositions).where("expositions.deadline_catalogs - ? <= ? AND expositors.catalog.completed =?",7.days, Date.today,false))
    aSetofExpositors.merge(self.joins(:expositions).where("expositions.deadline_credentials - ? <= ? AND expositors.credentials.any? =?",7.days, Date.Today,false))
    aSetofExpositors.merge(self.joins(:expositions).where("expositions.deadline_aditional_servicies - ? <= ? AND expositors.aditional_service.completed =?",7.days, Date.Today,false))
    aSetofExpositors.merge(self.joins(:expositions).where("expositions.deadline_infrastructures - ? <= ? AND expositors.infrastructure.completed =?",7.days, Date.Today,false))
    aSetofExpositors
  end

end
