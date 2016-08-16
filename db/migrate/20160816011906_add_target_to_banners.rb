class AddTargetToBanners < ActiveRecord::Migration
  def change
    add_column :banners, :target, :string
    add_column :banners, :target_id, :integer
  end
end
