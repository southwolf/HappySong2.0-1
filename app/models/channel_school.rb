class ChannelSchool < ActiveRecord::Base
  belongs_to :channel_user
  belongs_to :school

  #已经通过报备的学校
  scope :passed_school, -> { where(passed: true)}
end
