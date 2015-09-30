class StoreController < BaseController
  before_action :authenticate_user!
  layout "shop"
  def index
    @products = []
    category = Category.where(:name => "D类").first
    if category
      @products = category.products
    end
    # @products = Product.where(:storage => true)
    @storages = current_user.orders.stored
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
    current_user.save(:validate => false)
    redirect_to store_path
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

end




