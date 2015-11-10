module Cartable
  extend ActiveSupport::Concern
  included do
    before_filter :extract_shopping_cart
    before_filter :extract_store_cart
  end
  private
  def extract_shopping_cart
    shopping_cart_id = session[:shopping_cart_id]
    @cart = session[:shopping_cart_id] ? Cart.find(shopping_cart_id) : Cart.create
    # @cart = Cart.create
    session[:shopping_cart_id] = @cart.id
  end



  def extract_store_cart
    store_cart_id = session[:store_cart_id]
    @storecart = session[:store_cart_id] ? Cart.find(store_cart_id) : Cart.create
    # @cart = Cart.create
    session[:store_cart_id] = @storecart.id
  end
end