class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.string :name
      t.belongs_to :district

      t.timestamps
    end
  end
end
