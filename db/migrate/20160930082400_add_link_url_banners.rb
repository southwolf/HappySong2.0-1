class AddLinkUrlBanners < ActiveRecord::Migration
  def change
    add_column :banners, :link_url, :string
  end
end
