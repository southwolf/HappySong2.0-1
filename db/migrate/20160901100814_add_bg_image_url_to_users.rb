class AddBgImageUrlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bg_image_url, :string, default: "bg_image.png"
  end
end
