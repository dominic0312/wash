class AddPicPathToProduct < ActiveRecord::Migration
  def change
    add_column :products, :pic1, :string
    add_column :products, :pic2, :string
    add_column :products, :pic3, :string
    add_column :products, :pic4, :string
    add_column :products, :pic5, :string
    add_column :products, :pic6, :string
    add_column :products, :pic7, :string
  end
end
