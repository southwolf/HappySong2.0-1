class CreateOrgClasses < ActiveRecord::Migration[5.0]
  def change
    create_table :org_classes do |t|
      t.string :name
      t.references :school
      t.integer :grade_no
      t.integer :class_no
      t.string :code, comment: '班级码'
      t.references :teacher, comment: '班主任ID'

      t.timestamps
    end
    add_index(:org_classes, :code)
  end
end
