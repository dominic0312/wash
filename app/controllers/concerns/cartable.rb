module Cartable
  extend ActiveSupport::Concern
  included do
    before_filter :extract_shopping_cart
  end
  private
  def extract_shopping_cart
    shopping_cart_id = session[:shopping_cart_id]
    # @cart = session[:shopping_cart_id] ? Cart.find(shopping_cart_id) : Cart.create
    @cart = Cart.create
    session[:shopping_cart_id] = @cart.id
  end
end