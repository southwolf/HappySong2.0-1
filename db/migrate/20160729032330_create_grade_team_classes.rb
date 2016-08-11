class CreateGradeTeamClasses < ActiveRecord::Migration
  def change
    create_table :grade_team_classes do |t|
      t.string     :code
      t.belongs_to :grade
      t.belongs_to :team_class

      t.belongs_to :teacher

      t.timestamps
    end
  end
end
