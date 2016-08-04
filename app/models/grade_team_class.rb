class GradeTeamClass < ActiveRecord::Base
  belongs_to :grade
  belongs_to :team_class

  belongs_to :user
end
