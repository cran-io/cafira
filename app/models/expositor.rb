class Expositor < User
  has_many :expositions, :through => :exposition_expositors
  has_many :exposition_expositors
end
