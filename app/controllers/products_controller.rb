class ProductsController < BaseController

  layout "shop"
  before_filter :extract_shopping_cart
  def index
    @categories = Category.all
    if params[:category] == "all" || !params[:category]
      @products = Product.all
    else
      category = Category.find(params[:category])
      @products = category.products
    end
    @category = params[:category]
 end

  def buy
    @product = Product.find(params[:id])
    price = params[:product][:discounted_value]
    @cart.add(@product, price, params[:product][:amount].to_i)
    redirect_to product_path(@product)
  end

  def show
    @product = Product.find(params[:id])
    @items = Product.limit(5)
  end




  # private
  # def extract_shopping_cart
  #   shopping_cart_id = session[:shopping_cart_id]
  #   @cart = session[:shopping_cart_id] ? Cart.find(shopping_cart_id) : Cart.create
  #   session[:shopping_cart_id] = @cart.id
  # end

end
