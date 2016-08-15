
class AddViewCountToRecords < ActiveRecord::Migration
  def change
    add_column :records, :view_count, :integer, default: 0
  end
end
