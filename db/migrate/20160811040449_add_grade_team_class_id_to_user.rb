class AddGradeTeamClassIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :grade_team_class_id, :integer
  end
end
