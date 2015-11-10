class CartsController < BaseController
  before_action :authenticate_user!
  layout "front"

  def index

  end

  def show
    # @cart = session[:shopping_cart_id] ? Cart.find(shopping_cart_id) : Cart.create
  end

  def delete_item
    @cart_item = CartItem.find(params[:cart_item])
    @cart_item.destroy!
    redirect_to payment_path
  end

  def delete_store
    @cart_item = CartItem.find(params[:cart_item])
    @cart_item.destroy!
    redirect_to storecart_path
  end






end