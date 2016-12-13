class CreateStudentWorks < ActiveRecord::Migration[5.0]
  def change
    create_table :student_works do |t|
      t.references :student
      t.references :work
      t.integer :state

      t.timestamps
    end
  end
end
