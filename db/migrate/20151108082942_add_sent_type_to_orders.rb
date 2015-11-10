class AddSentTypeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :sent, :boolean, :default => false
  end
end
