class AddFollowersIncToCoupon < ActiveRecord::Migration
  def change
    add_column :coupons, :follower_inc, :integer, :default => 0
  end
end
