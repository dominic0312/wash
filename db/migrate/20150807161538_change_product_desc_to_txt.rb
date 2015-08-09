class ChangeProductDescToTxt < ActiveRecord::Migration
  def change
    remove_column :products, :desc
    add_column :products, :desc, :text
  end
end
