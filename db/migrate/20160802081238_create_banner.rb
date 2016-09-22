class CreateBanner < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.string     :cover_img
      t.string     :text
      t.references :targetable, polymorphic: true

      t.timestamps
    end
  end
end
