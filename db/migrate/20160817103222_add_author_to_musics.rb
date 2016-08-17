class AddAuthorToMusics < ActiveRecord::Migration
  def change
    add_column :musics, :author, :string
  end
end
