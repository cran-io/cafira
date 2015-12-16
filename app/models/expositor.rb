class Expositor < User
  has_many :expositions, :through => :exposition_expositors
  has_many :exposition_expositors, :dependent => :destroy
  has_many :credentials, :dependent => :destroy
  has_one :catalog, :dependent => :destroy
  has_one :aditional_service, :dependent => :destroy
  has_one :infrastructure, :dependent => :destroy

  #returns a Set of all expositors with uncompleted tasks and without much time to complete them
  def self.near_deadline
    aSetofExpositors = Set.new
    aSetofExpositors.merge(self.joins(:catalog).where("catalogs.completed = ?",false).joins(:expositions).where("expositions.deadline_catalogs <= ? AND expositions.active = ?",Date.today + 2.days,true))
    aSetofExpositors.merge(self.joins(:credentials).where(:credentials => {:id => nil}).joins(:expositions).where("expositions.deadline_credentials <= ? AND expositions.active = ?",Date.today + 2.days,true))
    aSetofExpositors.merge(self.joins(:aditional_service).where("aditional_services.completed =?",false).joins(:expositions).where("expositions.deadline_aditional_services <= ? AND expositions.active = ?",Date.today + 2.days,true))
    aSetofExpositors.merge(self.joins(:infrastructure).where("infrastructures.completed =?",false).joins(:expositions).where("expositions.deadline_infrastructures <= ? AND expositions.active = ?",Date.today + 2.days,true))
    aSetofExpositors
  end

  def name_and_email
    (name || "") + " (" + email + ")"
  end

end
