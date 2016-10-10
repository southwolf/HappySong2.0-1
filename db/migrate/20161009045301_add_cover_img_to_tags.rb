class AddCoverImgToTags < ActiveRecord::Migration
  def change
    add_column :tags, :cover_img, :string
  end
end
