class Exposition < ActiveRecord::Base
  has_many :expositors, :through => :exposition_expositors
  has_many :exposition_expositors, :dependent => :destroy
  has_many :exposition_files, :dependent => :destroy
  accepts_nested_attributes_for :exposition_files

  validates :name, :presence => true, :length => { :in => 2..50 }
  validates :initialized_at, :presence => true, :on => :create
  validates :ends_at, :presence => true, :on => :create
  validate :ends_at, :if => :ends_at_after_initialized?
  validates :deadline_catalogs, :deadline_credentials, :deadline_aditional_services, :deadline_infrastructures, :days_to_notify_deadlines, :presence => true

  private
  def ends_at_after_initialized?
  	if ends_at && initialized_at
  	  if ends_at < initialized_at
  	    errors.add(:ends_at, 'Fecha de finalización debe ser después de la de inicialización')
  	  end
  	end
  end

end
