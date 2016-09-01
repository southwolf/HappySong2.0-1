class AddBgImageUrlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bg_iamge_url, :string, default: "bg_image.png"
  end
end
