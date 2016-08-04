class CreateTeamClasses < ActiveRecord::Migration
  def change
    create_table :team_classes do |t|
      t.string :name
      t.string :code
      t.timestamps
    end
  end
end
