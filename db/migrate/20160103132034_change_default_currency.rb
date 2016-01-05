class ChangeDefaultCurrency < ActiveRecord::Migration
  def change
    remove_column :cart_items, :price_currency
    add_column :cart_items, :price_currency, :string, :default => "USD", :null => false
  end
end
