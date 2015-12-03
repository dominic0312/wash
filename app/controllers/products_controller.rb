class ProductsController < BaseController

  layout "shop"
  before_filter :extract_shopping_cart

  def index
    @categories = Category.where.not(name: "会员专享")
    @kinds = Kind.all
    @providers = Provider.all
    @products = Product.where(:is_member => false)

    if params[:kind] == "all" || !params[:kind]
    else
      # category = Category.find(params[:category])
      @products = @products.where(:kind_id => params[:kind].to_i)
    end

    if params[:provider] == "all" || !params[:provider]

    else
      # category = Category.find(params[:category])
      @products = @products.where(:provider_id => params[:provider].to_i)
    end

    if params[:category] == "all" || !params[:category]

    else
      category = Category.find(params[:category])
      if category
        @products = @products.where(:category_id => params[:category].to_i)
        if category.name == "会员专享"
          if !current_user || current_user.level == "注册用户"
            @products = []
          end
        end
      end

    end


    @category = params[:category]
    @kind = params[:kind]
    @provider = params[:provider]
  end

  def buy
    @product = Product.find(params[:id])
    price = 0
    if current_user.level == "一级会员"
      price = @product.member_price
    else
      price = @product.price
    end

    if  params[:product][:label_id]

      @cart.add(@product, price, params[:product][:amount].to_i, attributes: {label: params[:product][:label_id]})
    else
      @cart.add(@product, price, params[:product][:amount].to_i)
    end
    if params[:product][:source]
      redirect_to put_store_path(:id => @product.id) and return
    end
    redirect_to product_path(@product)
  end

  def show
    @product = Product.find(params[:id])
    @items = Product.limit(5)
  end


  def members

    if !current_user
      redirect_to new_user_session_path and return
    end

    @providers = Provider.all
    @products = Product.where(:is_member => true)


    if params[:provider] == "all" || !params[:provider]

    else
      # category = Category.find(params[:category])
      @products = @products.where(:provider_id => params[:provider].to_i)
    end

    @provider = params[:provider]


    if !current_user || current_user.level == "注册用户"
      render "invalid" and return
    end


  end


  # private
  # def extract_shopping_cart
  #   shopping_cart_id = session[:shopping_cart_id]
  #   @cart = session[:shopping_cart_id] ? Cart.find(shopping_cart_id) : Cart.create
  #   session[:shopping_cart_id] = @cart.id
  # end

end
