class AddSchoolIdToGradeTeamClasses < ActiveRecord::Migration
  def change
    add_column :grade_team_classes, :school_id, :integer
  end
end
