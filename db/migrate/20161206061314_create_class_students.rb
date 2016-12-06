class CreateClassStudents < ActiveRecord::Migration[5.0]
  def change
    create_table :class_students do |t|
      t.references :class
      t.references :student

      t.timestamps
    end
  end
end
