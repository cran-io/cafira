class Expositor < User
  has_many :expositions, :through => :exposition_expositors
  has_many :exposition_expositors, :dependent => :destroy
  has_many :credentials, :dependent => :destroy
  has_one :catalog, :dependent => :destroy
  has_one :aditional_service, :dependent => :destroy
  has_one :infrastructure, :dependent => :destroy
end
