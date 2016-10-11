class CreateWorkToStudents < ActiveRecord::Migration
  def change
    create_table :work_to_students do |t|
      t.belongs_to :work
      t.belongs_to :student

      t.boolean    :complete, default: false

      t.timestamps
    end
  end
end
