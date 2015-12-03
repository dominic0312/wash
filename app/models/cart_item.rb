class CartItem < ActiveRecord::Base
  acts_as_shopping_cart_item_for :cart

  def label_cn
    if self.label
      self.label
    else
      "普通"
    end
  end
end