class ChannelSchool < ActiveRecord::Base
  belongs_to :channel_user
  belongs_to :school
end
