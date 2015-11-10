class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.integer :pointa
      t.integer :pointb
      t.integer :pointc
      t.string :year
      t.integer :follower
      t.integer :user_id


      t.timestamps null: false
    end
  end
end
