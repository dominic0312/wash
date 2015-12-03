class AddCents2ToCartItme < ActiveRecord::Migration
  def change
    add_column :cart_items, :price_cents, :integer, :default => 0, :null => false
  end
end
