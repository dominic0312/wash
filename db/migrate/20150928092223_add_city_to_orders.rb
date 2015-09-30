class AddCityToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :city, :string
    add_column :orders, :address, :string
    add_column :orders, :phone, :string
  end
end
