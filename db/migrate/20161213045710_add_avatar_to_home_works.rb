class AddAvatarToHomeWorks < ActiveRecord::Migration[5.0]
  def change
    add_column :home_works, :avatar, :string
  end
end
