class Work < ActiveRecord::Base
  belongs_to :teacher, class_name: "User"
  has_many   :work_to_teams
  has_many   :grade_team_classes, through: :work_to_teams

  has_many   :work_to_students
  has_many   :students, class_name: "User",
                        through: :work_to_students
end
