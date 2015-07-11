class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :mobile
      t.string :address
      t.string :name
      t.string :uname
      t.string :level, :default => "注册用户"

      t.timestamps
    end
  end
end
