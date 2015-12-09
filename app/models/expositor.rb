class Expositor < User
  has_many :expositions, :through => :exposition_expositors
  has_many :exposition_expositors
  has_many :credentials
  has_one :catalog
  has_one :aditional_service
  has_one :infrastructure
end
