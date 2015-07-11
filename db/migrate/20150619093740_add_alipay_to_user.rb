class AddAlipayToUser < ActiveRecord::Migration
  def change
    add_column :users, :alipay, :string,  :default => ''
    add_column :users, :brand_name, :string,  :default => ''
  end
end
