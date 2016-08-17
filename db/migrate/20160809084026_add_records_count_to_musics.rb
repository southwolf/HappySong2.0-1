class AddRecordsCountToMusics < ActiveRecord::Migration
  def change
    add_column :musics, :records_count, :integer, default: 0
  end
end
