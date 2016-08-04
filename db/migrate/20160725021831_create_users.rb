class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :phone
      t.string  :name
      t.string  :uid
      t.string  :avatar,   default: 'happysong_logo.jpg'
      t.string  :sex
      t.integer :age
      t.string  :desc
      t.boolean :vip,      default: false
      t.boolean :is_first, default: true
      t.string :code

      t.timestamps
    end
  end
end
