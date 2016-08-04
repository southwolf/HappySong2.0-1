class Grade < ActiveRecord::Base
  has_and_belongs_to_many :schools, join_table: :grade_join_schools

  has_many :grade_team_classes
  has_many :team_classes, :through => :grade_team_classes
end
