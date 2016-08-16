class AddIsHotToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :is_hot, :boolean, default: false
  end
end
