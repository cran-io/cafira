class ExpositionExpositor < ActiveRecord::Base
  belongs_to :exposition
  belongs_to :expositor

  before_create :init_expositor

  private

  def init_expositor
    expositor = Expositor.find(self.expositor_id)
    expositor.destroy_expositor_info
    expositor.build_expositor
  end

end
