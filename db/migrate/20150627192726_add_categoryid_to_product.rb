class AddCategoryidToProduct < ActiveRecord::Migration
  def change
    add_column :products, :category_id, :integer
  end
end
