class CreateGradeJoinSchool < ActiveRecord::Migration
  def change
    create_table :grade_join_schools do |t|
      t.belongs_to :grade
      t.belongs_to :school
    end

    add_index :grade_join_schools, [:grade_id, :school_id]
  end
end
