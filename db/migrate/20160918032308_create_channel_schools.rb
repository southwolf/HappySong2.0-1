class CreateChannelSchools < ActiveRecord::Migration
  def change
    create_table :channel_schools do |t|
      t.belongs_to :channel_user
      t.belongs_to :school

      t.timestamps
    end
  end
end
