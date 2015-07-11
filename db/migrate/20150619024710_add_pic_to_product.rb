class AddPicToProduct < ActiveRecord::Migration
  def up
    add_attachment :products, :pic
  end

  def down
    remove_attachment :products, :pic
  end
end
