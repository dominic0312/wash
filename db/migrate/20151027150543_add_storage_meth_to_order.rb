class AddStorageMethToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :storage_method, :string, :default => '囤货'
  end
end
