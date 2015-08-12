class AddPicToPictures < ActiveRecord::Migration
  def up
    add_attachment :pictures, :pic
  end

  def down
    remove_attachment :pictures, :pic
  end
end
