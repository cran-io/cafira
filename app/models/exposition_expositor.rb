class ExpositionExpositor < ActiveRecord::Base
  belongs_to :exposition
  belongs_to :expositor
end