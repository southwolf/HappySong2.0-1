class Music < ActiveRecord::Base
  has_many   :records
  belongs_to :music_types
end
