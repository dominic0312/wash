class AddStatusToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :status, :string, :default => '未处理'
  end
end
