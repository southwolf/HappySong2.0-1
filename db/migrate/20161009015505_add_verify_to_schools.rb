class AddVerifyToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :verify, :boolean, default: false
  end
end
