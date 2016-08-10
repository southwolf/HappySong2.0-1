class AddRecordsCountToMusics < ActiveRecord::Migration
  def change
    add_column :musics, :records_count, :integer
  end
end
