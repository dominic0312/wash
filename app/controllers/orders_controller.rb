class OrdersController < BaseController
  layout "shop"
  include Cartable
  before_filter :extract_shopping_cart
  before_action :authenticate_user!

  def index
    # @orders = current_user.orders.normal.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    if params[:status]
      @status = params[:status]
    else @status = "unpaid"
    end

    if @status == "unpaid"
      @orders = current_user.orders.normal.unpaid.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    elsif @status == "paid"
      @orders = current_user.orders.normal.paid.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
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

  def go_alipay(sid, orderid, fee)

    Alipay::Service.create_direct_pay_by_user_url(
        out_trade_no: sid,
        subject: orderid,
        total_fee: fee,
        return_url: 'http://www.jiajiaxishangcheng.com/alipay_return/' + sid,
        notify_url: 'http://www.jiajiaxishangcheng.com/alipay_notify/' + sid
    )

  end


  def charge_notify
    render plain: "success"
  end

  def alipay_notify
    render plain: "success"
  end


  def charge_return
    oid = params[:order]
    @info = ""

    notify_params = params.except(*request.path_parameters.keys)

    if !Alipay::Notify.verify?(notify_params)
      @info = "请求不是来自支付宝, 请联系管理员"
      return
    end



    charge = Charge.where(:sn => oid).first
    if charge && !charge.finished
       user = User.find(charge.user_id)
       if user
         user.balance += charge.amount
         user.save!
         charge.finished = true
         charge.save!
         @info = "充值成功, 充值金额为#{charge.amount}"
       else
         @info = "充值失败, 请咨询管理员"
       end
    else
      @info = "充值失败, 请咨询管理员"
    end
  end

  def alipay_return

    @oid = params[:order]
    @result = ""
    @info = "订单支付成功, 请等待商家发货"

    notify_params = params.except(*request.path_parameters.keys)
    if !Alipay::Notify.verify?(notify_params)
      @info = "请求不是来自支付宝, 请联系管理员"
      return
    end


    order = Order.where(:sn => @oid).first
    if order && !order.paid
      order.paid = true


      charge = Charge.new(:user_id => order.user_id, :amount => order.total_value)

      charge.sn = "BUY" + Time.now.to_formatted_s(:number)
      charge.order_id = order.id
      charge.finished = true
      charge.chr_type = "购物"
      charge.save!
      order.charge_id = charge.id
      order.save!

      @result = "success"
      @orderid = order.id

    else
      @info = "购买失败, 请咨询管理员"
      @result = "failed"
    end

  end


  def alipay_route

  end



  def show_order
    @order = Order.where(:sn => params[:order]).first

    if !@order | @order.is_processed == "已处理"
      redirect_to error_path and return
    end

    @url = go_alipay(@order.sn, "家家商城订单" + @order.sn, @order.total_value)
  end

  def alipay
    order_sn = ""
    agent = nil
    if params[:send] == "送货"
      agent = User.find(params[:agent])
      if agent
        @results = agent.process_cart(@cart)
        if @results != "success"
           @notice = @results
           render "payment" and return
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
      end
    end


    @order = Order.create

    if params[:send] == "送货"
      @order.sent = true
      @order.agent_id = agent.id
      @order.storage_method = "送货"
    else
      @order.storage_method = "发货"
    end


    @cart.cart_items.each do |t|
      p = OrderItem.create
      p.product_id = t.item.id
      p.order_price = t.price
      p.label = t.label
      p.amount = t.quantity
      @order.order_items<<p
    end

    @order.phone = params[:order][:phone]
    @order.address = params[:order][:address]
    @order.city = params[:city]
    @order.province = params[:province]
    @order.district = params[:district]





    if params[:payment]=="alipay"
      current_user.orders<<@order
      @cart.clear
      @order.save!
      redirect_to alipay_route_path(@order.sn) and return
    end


    if params[:payment]=="balance"
        @order.paid = true

        current_user.orders<<@order
        current_user.balance -= @cart.total.to_i
        current_user.save!

        @order.save!
        @cart.clear
        @notice = "支付完成"

        render "payment" and return
      end

    if params[:payment]=="offline"

        @order.paid = false

        current_user.orders<<@order
        @order.save!
        # @cart.clear
        @notice = "购买完成"
        render "payment" and return
      end
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
