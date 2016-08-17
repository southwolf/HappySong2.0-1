class AddCoverImgToMusics < ActiveRecord::Migration
  def change
    add_column :musics, :cover_img, :string
  end
end
