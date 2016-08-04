class CreateSchoolsTeamClasses < ActiveRecord::Migration
  def change
    create_table :schools_team_classes, id: false do |t|
      t.belongs_to :school
      t.belongs_to :team_class
    end
    add_index :schools_team_classes, [:school_id, :team_class_id]
  end
end
