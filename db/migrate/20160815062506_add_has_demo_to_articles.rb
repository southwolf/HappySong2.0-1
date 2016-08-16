class AddHasDemoToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :has_demo, :boolean, default: false
  end
end
