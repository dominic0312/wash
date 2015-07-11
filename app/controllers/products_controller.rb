class ProductsController < BaseController

  layout "front"
  before_filter :extract_shopping_cart
  def index
    @categories = Category.all
    if params[:category] == "all" || !params[:category]
      @products = Product.all
    else
      category = Category.find(params[:category])
      @products = category.products
    end
 end

  def buy
    @product = Product.find(params[:id])
    @cart.add(@product, @product.price, params[:product][:amount].to_i)
    redirect_to products_path
  end

  def show
    @product = Product.find(params[:id])
  end




  # private
  # def extract_shopping_cart
  #   shopping_cart_id = session[:shopping_cart_id]
  #   @cart = session[:shopping_cart_id] ? Cart.find(shopping_cart_id) : Cart.create
  #   session[:shopping_cart_id] = @cart.id
  # end

end
