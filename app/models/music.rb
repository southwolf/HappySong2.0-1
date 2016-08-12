class Music < ActiveRecord::Base
  has_many   :records
  belongs_to :music_type
end
