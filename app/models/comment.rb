class Comment < ActiveRecord::Base
  belongs_to :architect
  belongs_to :blueprint_file
end
