class TeamClass < ActiveRecord::Base
  has_and_belongs_to_many :schools
  has_many :grade_team_classes
  has_many :team_classes, :through => :grade_team_classes
end
