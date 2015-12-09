class Infrastructure < ActiveRecord::Base
  belongs_to :expositor
  has_many :blueprint_files
end
