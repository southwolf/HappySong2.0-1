class CreateClassWorks < ActiveRecord::Migration[5.0]
  def change
    create_table :class_works do |t|
      t.references :class
      t.references :work

      t.timestamps
    end
  end
end
