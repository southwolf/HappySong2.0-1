class School < ActiveRecord::Base
  belongs_to :district
  has_and_belongs_to_many :grades, :join_table => :grade_join_schools
  has_and_belongs_to_many :team_classes
  has_many :grade_team_classes

  has_many :channel_schools
  has_many :channel_users, :through => :channel_schools

end
