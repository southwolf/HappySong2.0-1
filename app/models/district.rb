class District < ActiveRecord::Base
  belongs_to :city
  has_many   :schools
  has_many   :channel_users
end
