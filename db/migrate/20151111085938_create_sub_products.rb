class CreateSubProducts < ActiveRecord::Migration
  def change
    create_table :sub_products do |t|
      t.decimal :price
      t.integer :product_id
      t.string :weight
      t.string :color
      t.string :kind
      t.timestamps null: false
    end
  end
end
