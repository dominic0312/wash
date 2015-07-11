class OrdersController < BaseController
  layout "front"
  include Cartable
   before_filter :extract_shopping_cart
  before_action :authenticate_user!

  def index
    @orders = current_user.orders
  end


  def payment
    #
    # @product = Product.find(params[:id])
    # @cart.add(@product, @product.price)
  end


  def alipay
    if current_user.balance < @cart.subtotal
      flash[:info] = "账户余额不足, 请充值"
    else
      current_user.balance -= @cart.subtotal
      Product.process_cart(@cart)
      order = Order.create
      @cart.cart_items.each do |t|
        p = OrderItem.create
        p.product_id = t.item.id
        p.amount = t.item.amount
        order.order_items<<p
      end
      order.save!
      current_user.orders<<order
      current_user.add_point(@cart.subtotal.to_i)
      current_user.save
      @cart.clear
      flash[:info] = "购买完成"
    end
    render "payment"
  end
end
