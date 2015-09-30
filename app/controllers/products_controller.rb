class ProductsController < BaseController

  layout "shop"
  before_filter :extract_shopping_cart
  def index
    @categories = Category.all
    @kinds = Kind.all
    @products = Product.all
    if params[:category] == "all" || !params[:category]

    else
      # category = Category.find(params[:category])
      @products = @products.where(:category_id => params[:category].to_i )
    end

    if params[:kind] == "all" || !params[:kind]

    else
      # category = Category.find(params[:category])
      @products = @products.where(:kind_id => params[:kind].to_i )
    end
  @category = params[:category]
    @kind = params[:kind]
 end

  def buy
    @product = Product.find(params[:id])
    price = params[:product][:discounted_value]
    @cart.add(@product, price, params[:product][:amount].to_i)
    if params[:product][:source]
      redirect_to  put_store_path(:id => @product.id) and return
    end


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
