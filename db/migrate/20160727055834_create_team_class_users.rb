class CreateTeamClassUsers < ActiveRecord::Migration
  def change
    create_table :team_class_users do |t|
      t.belongs_to :user
      t.belongs_to :team_class

      t.timestamps
    end

    add_index :team_class_users, :user_id
    add_index :team_class_users, :team_class_id
    add_index :team_class_users, [:user_id, :team_class_id]
  end
end
