class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.integer :amount
      t.integer :product_id
      t.decimal :totalvalue
      t.timestamps null: false
    end
  end
end
