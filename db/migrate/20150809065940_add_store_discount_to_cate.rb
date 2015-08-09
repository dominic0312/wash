class AddStoreDiscountToCate < ActiveRecord::Migration
  def change
    add_column :categories, :store_discount, :integer
  end
end
