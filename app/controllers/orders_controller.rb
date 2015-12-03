class OrdersController < BaseController
  layout "shop"
  include Cartable
  before_filter :extract_shopping_cart
  before_action :authenticate_user!

  def index
    # @orders = current_user.orders.normal.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    if params[:status]
      @status = params[:status]
    else @status = "unprocessed"
    end

    if @status == "unprocessed"
      @orders = current_user.orders.normal.unprocessed.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    else
      @orders = current_user.orders.normal.history.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    end
  end

  def show
    @order = Order.find(params[:id])
  end


  def payment
    #
    # @product = Product.find(params[:id])
    # @cart.add(@product, @product.price)
    @order = Order.new
  end


  #
  # def alipay
  #   if current_user.balance < @cart.subtotal
  #     flash[:info] = "账户余额不足, 请充值"
  #   else
  #     current_user.balance -= @cart.subtotal
  #     Product.process_cart(@cart)
  #     order = Order.create
  #     @cart.cart_items.each do |t|
  #       p = OrderItem.create
  #       p.product_id = t.item.id
  #       p.amount = t.item.amount
  #       order.order_items<<p
  #     end
  #     order.save!
  #     current_user.orders<<order
  #     current_user.add_point(@cart.subtotal.to_i)
  #     current_user.save
  #     @cart.clear
  #     flash[:info] = "购买完成"
  #   end
  #   render "payment"
  # end

  def alipay
    # Product.process_cart(@cart)

    order_sn = ""
    agent = nil
    if params[:send] == "送货"
      agent = User.find(params[:agent])
      if agent
        @results = agent.process_cart(@cart)
        if @results != "success"
          @notice = @results
          render "payment" and return
        else


        end
      else
        @notice = "囤货商不存在"
        render "payment" and return

      end
    else
      @results = Product.process_cart(@cart)
      if @results != "success"
        @notice = @results
        render "payment" and return

      else
      end
    end


    order = Order.create
    if params[:send] == "送货"

      order.sent = true
      order.agent_id = agent.id
      order.storage_method = "送货"
      puts "SHOULD NOT BE HERE ***************************"
    else
      order.storage_method = "发货"
    end


    @cart.cart_items.each do |t|
      p = OrderItem.create
      p.product_id = t.item.id
      p.order_price = t.price
      p.label = t.label


      p.amount = t.quantity
      order.order_items<<p
    end

    order.phone = params[:order][:phone]
    order.address = params[:order][:address]
    order.city = params[:city]
    order.province = params[:province]
    order.district = params[:district]


    current_user.orders<<order
    order.save!
    # current_user.add_point(@cart.subtotal.to_i)
    # current_user.save


    @cart.clear
    @notice = "购买完成"

    render "payment" and return

  end


  def store
    if params[:store]
      Product.process_cart(@storecart)
      order = Order.create
      @storecart.cart_items.each do |t|
        p = OrderItem.create
        p.product_id = t.item.id
        p.order_price = 0
        p.label = t.label
        p.amount = t.quantity
        order.order_items<<p
      end
      # order.phone = params[:order][:phone]
      # order.address = params[:order][:address]
      # order.city = params[:city]
      # order.province = params[:province]
      # order.district = params[:district]
      order.storage = true
      order.storage_method = "囤货"
      order.save!
      current_user.orders<<order
      @storecart.clear
      # # flash[:info] = "购买完成"

      redirect_to storecart_path


      # render :js => "alert('store')"

    elsif params[:deliver]
      render :js => "alert('deliver')"
    else
      render :js => "alert('nothing')"
    end
    # Product.process_cart(@cart)
    # order = Order.create
    # @cart.cart_items.each do |t|
    #   p = OrderItem.create
    #   p.product_id = t.item.id
    #   p.order_price = t.price
    #   p.amount = t.quantity
    #   order.order_items<<p
    # end
    # order.phone = params[:order][:phone]
    # order.address = params[:order][:address]
    # order.city = params[:city]
    # order.province = params[:province]
    # order.district = params[:district]
    # order.save!
    # current_user.orders<<order
    # # current_user.add_point(@cart.subtotal.to_i)
    # current_user.save
    # @cart.clear
    # # flash[:info] = "购买完成"
    #
    # render "payment"

  end


  def create

  end
end
