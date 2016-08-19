class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.belongs_to :user
      t.references :reportable, polymorphic: true

      t.timestamps
    end
  end
end
