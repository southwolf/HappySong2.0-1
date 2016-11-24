class CreateOrgSchools < ActiveRecord::Migration[5.0]
  def change
    create_table :org_schools do |t|
      t.string :name
      t.references :nation

      t.timestamps
    end
  end
end
