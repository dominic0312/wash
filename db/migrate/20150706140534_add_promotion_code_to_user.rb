class AddPromotionCodeToUser < ActiveRecord::Migration
  def change
    add_column :users, :promotion_code, :string
  end
end
