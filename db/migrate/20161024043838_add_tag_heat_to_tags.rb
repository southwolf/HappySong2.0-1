class AddTagHeatToTags < ActiveRecord::Migration
  def change
    add_column :tags, :tag_heat, :integer, default: 0
  end
end
