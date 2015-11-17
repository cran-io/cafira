class Exposition < ActiveRecord::Base
  has_many :expositors, :through => :exposition_expositors
  has_many :exposition_expositors

  validates :name, :presence => true, :length => { :in => 2..50 }
  validates :initialized_at, :presence => true, :on => :create
  validates :ends_at, :presence => true, :on => :create
  validate :ends_at, :if => :ends_at_after_initialized?

  private
  def ends_at_after_initialized?
	if ends_at && initialized_at
	  if ends_at < initialized_at
	    errors.add(:ends_at, 'Fecha de finalización debe ser después de la de inicialización')
	  end
	end
  end

end
