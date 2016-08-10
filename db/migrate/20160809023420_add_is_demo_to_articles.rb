class AddIsDemoToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :is_demo, :boolean, default: false
  end
end
