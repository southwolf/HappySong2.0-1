class AddRecommendToTags < ActiveRecord::Migration
  def change
    add_column :tags, :recommend, :boolean, default: false
  end
end
