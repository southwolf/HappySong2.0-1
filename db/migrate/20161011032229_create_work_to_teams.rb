class CreateWorkToTeams < ActiveRecord::Migration
  def change
    create_table :work_to_teams do |t|
      t.belongs_to :work
      t.belongs_to :grade_team_class

      t.timestamps
    end
  end
end
