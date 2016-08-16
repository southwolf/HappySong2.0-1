class AddCommentsCountToRecords < ActiveRecord::Migration
  def change
    add_column :records, :comments_count, :integer, default: 0
  end
end
