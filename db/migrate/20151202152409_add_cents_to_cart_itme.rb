class AddCentsToCartItme < ActiveRecord::Migration
  def change
    add_column :cart_items, :price_currency, :string, :default => "CNY", :null => false
  end
end
