class CreateCateItem < ActiveRecord::Migration
  def change
    create_table :cate_items do |t|
      t.string :name
      t.belongs_to :category
      t.timestamps
    end
  end
end
