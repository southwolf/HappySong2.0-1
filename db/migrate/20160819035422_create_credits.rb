class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.integer :point, default: 0
      t.integer :used,  default: 0
      t.timestamps
    end
  end
end
