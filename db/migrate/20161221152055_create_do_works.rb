class CreateDoWorks < ActiveRecord::Migration[5.0]
  def change
    create_table :do_works do |t|
      t.references :student_work
      t.string :content
      t.string :type
      t.references :user

      t.timestamps
    end
  end
end
