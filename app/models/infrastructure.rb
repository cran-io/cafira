class Infrastructure < ActiveRecord::Base
  belongs_to :expositor
  has_many :blueprint_files, :dependent => :destroy
  accepts_nested_attributes_for :blueprint_files
end
