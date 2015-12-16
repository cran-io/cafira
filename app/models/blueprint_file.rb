class BlueprintFile < ActiveRecord::Base
  belongs_to :infrastructure
  has_attached_file :attachment
  validates_attachment :attachment,
    content_type: {
     content_type: ['image/jpg', 'image/jpeg', 'image/png', 'application/pdf']
    },
    size: {
     in: 0..5.megabytes
    }

    ransacker :bp_state,
    formatter: -> (state) {
      case state.to_i
      when 2
        true
      when 1
        false
      when 0
        nil
      else
      end
    } do |parent|
      parent.table[:state]
    end
end
