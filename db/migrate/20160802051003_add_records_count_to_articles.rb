class AddRecordsCountToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :records_count, :integer, default: 0
  end
end
