class AddProcessedToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :processed, :boolean, :default => false
  end
end
