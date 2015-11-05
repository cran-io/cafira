class Exposition < ActiveRecord::Base
  has_many :expositors, :through => :exposition_expositors
  has_many :exposition_expositors
end
