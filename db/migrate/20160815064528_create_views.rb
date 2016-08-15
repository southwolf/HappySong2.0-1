class CreateViews < ActiveRecord::Migration
  def change
    create_table :views do |t|
      t.belongs_to :viewer
      t.belongs_to :view_record
      t.integer    :num, default: 1

      t.timestamps
    end
  end
end
