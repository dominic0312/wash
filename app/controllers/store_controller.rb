class StoreController < BaseController
  before_action :authenticate_user!
  before_action :extract_store_cart
  layout "shop"







  def index
    # @products = []
    # category = Category.where(:name => "D类").first
    # if category
    #   @products = category.products
    # end
    @products = Product.where(:storage => true)
    @storages = current_user.orders.stored
    @user = current_user



    @categories = Category.all
    @kinds = Kind.all
    @providers = Provider.all
    # @products = Product.all


    if params[:kind] == "all" || !params[:kind]

    else
      # category = Category.find(params[:category])
      @products = @products.where(:kind_id => params[:kind].to_i )
    end

    if params[:provider] == "all" || !params[:provider]

    else
      # category = Category.find(params[:category])
      @products = @products.where(:provider_id => params[:provider].to_i )
    end

    if params[:category] == "all" || !params[:category]

    else
      category = Category.find(params[:category])
      if category
        @products = @products.where(:category_id => params[:category].to_i )
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

  def create
    # uname = params[:user][:mobile]
    # if User.exists?(:mobile => uname)
    #    redirect_to network_path and return
    # end
    #
    #
    # u = User.new(:mobile => uname)
    # u.parent = current_user
    # u.source = "input"
    # u.save!
    # redirect_to network_path
  end


  def req_store
    current_user.storage = "request"
    current_user.bank_card = params[:user][:bank_card]
    current_user.alipay = params[:user][:alipay]
    current_user.address = params[:user][:address]
    current_user.bank_card = params[:user][:bank_card]
    current_user.person_id = params[:user][:person_id]
    current_user.brand_name = params[:user][:brand_name]
    current_user.city = params[:city]
    current_user.province = params[:province]
    current_user.district = params[:district]
    current_user.save(:validate => false)
    redirect_to store_path
  end

  def req_dealer
    @users=[]
    if params[:district] == ""
       render :json => @users and return
    else
      @users = User.where(:level => "囤货商", :district => params[:district])
      # @users = User.all
      puts @users.size
      render :json => @users and return
    end
    # render :js => "alert('hello')"
  end


  def put_store
    @items = Product.limit(5)
     @product = Product.find(params[:id])
     render "products/store"
  end


  def push_store
    product = Product.find(params[:id])
    total_price = product.price * params[:product][:amount].to_i
    puts "id is:" + params[:id]
    puts "amount is :" + params[:product][:amount]
    if current_user.balance < total_price
      flash[:info] = "账户余额不足, 请充值"
      redirect_to put_store_path(:id => params[:id]) and return
    else
      current_user.balance -= total_price
      order = Order.create
      order.storage = true
      p = OrderItem.create
      p.product_id = params[:id]
      p.amount = params[:product][:amount]
      order.order_items<<p
      order.save!
      current_user.orders<<order
      current_user.add_point(total_price.to_i)
      current_user.save(:validate => false)

      flash[:info] = "购买完成"
    end
    redirect_to store_path

  end


  def addcart
    @product = Product.find(params[:id])
    price = params[:product][:discounted_value]
    @storecart.add(@product, price, params[:product][:amount].to_i)

      redirect_to  put_store_path(:id => @product.id) and return
  end


  def storecart
    @order = Order.new
  end

  def orders
   @orders = current_user.orders.stored.unprocessed
  end

  def list
    @items = current_user.order_items
  end


  def sent
    @orders = current_user.orders.sent
  end

  def store_order_detail
    @order = Order.find(params[:id])
  end


end




