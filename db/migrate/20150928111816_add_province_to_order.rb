class AddProvinceToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :province, :string
    add_column :orders, :district, :string
  end
end
