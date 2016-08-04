class CreateDistricts < ActiveRecord::Migration
  def change
    create_table :districts do |t|
      t.string :name
      t.belongs_to :city

      t.timestamps
    end
  end
end
