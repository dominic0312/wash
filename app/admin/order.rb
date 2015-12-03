ActiveAdmin.register Order do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#

  actions :index, :show, :edit, :destroy, :update
  filter :storage
  filter :processed, :default => false

  # before_filter :only => [:index] do
  #   # if params['commit'].blank?
  #     #country_contains or country_eq .. or depending of your filter type
  #     params['q'] = {:processed => false}
  #   # end
  # end
  # filter :desc


  permit_params :processed, :storage, :shipment
  form do |f|
    f.inputs "订单状态" do
      # f.input :processed
      f.input :shipment
    end


    f.actions
  end


  show do |ad|
    attributes_table do

      row "订单号" do
        ad.sn
      end
      row "客户姓名" do
        ad.user.uname
      end

      row "客户手机" do
        link_to "#{ad.user.mobile}", admin_user_path(ad.user)

      end

      row "是否囤货" do
        ad.is_storage
      end

      row "囤货方式" do
        ad.storage_method
      end

      row "是否处理" do
        ad.is_processed
      end

      row "订单总额" do
        ad.total_value
      end

      row "送货地址" do
        ad.full_address
      end

      row "送货电话" do
        ad.phone
      end

      row "运费" do
        ad.shipment
      end

      row "订单处理" do
        if !order.processed
          link_to "结束订单", "/process_order/#{ad.id}"
        else
          "无操作"
        end

      end

      # row :amount
      # row :price
      # row :category, ad.category.name
      # row :desc
      # row :is_storage
      # row :pic do
      #   image_tag(ad.pic.url(:thumb))
      # end
      # Will display the image on show object page
    end

    div do

      table_for order.order_items do
        column "产品名称" do |item|
          link_to "#{item.product.name} ", admin_product_path(item.product)
        end

        column "产品规格" do |item|
          item.label_cn
        end

        column "产品原价" do |item|
          item.product.price
        end

        column "订货价格" do |item|
          item.order_price
        end

        column "订货数量" do |item|
          item.amount
        end
        column "价格总计" do |item|
          item.total_value
        end
        # column :mobile do |child|
        #   link_to "#{child.mobile} ", admin_user_path(child)
        # end
        # column :uname
        # column :pointa
        # column :pointb
        # column :pointc
        # column :pointd
        # column :created_at


      end
      # if user.children.size > 0
      #   user.children.each do |c|
      #     link_to "下级", admin_user_path(user)
      #   end
      # else
      #   "0"
      # end
    end


    # attributes_table do
    #   ad.order_items.each do |item|
    #     row "产品名称" do
    #       link_to item.product.name, admin_product_path(item.product)
    #     end
    #
    #     row "产品数量" do
    #       item.amount
    #     end
    #
    #     row "产品总价" do
    #       item.totalvalue
    #     end
    #
    #
    #
    #   end
    # end

  end

  #


  index do
    selectable_column
    column("订单号") { |order| order.sn }
    column("客户", :sortable => :id) { |order| link_to "#{order.user.mobile} ", admin_user_path(order.user) }
    column("下单时间") { |order| order.created_at }
    column("是否囤货") { |order| order.is_storage }
    column("处理状况") { |order| order.is_processed }
    column("查看详情") { |order| link_to "查看", admin_order_path(order) }
  end


  # member_action :finish, method: :get do
  #   #   # resource.processed = true
  #   #   # # resource.level = "囤货商"
  #   #   # resource.save(:validate => false)
  #   # redirect_to admin_order_path, notice: "订单"+ resource.id + "已经被处理成功"
  # end


  controller do
    # This code is evaluated within the controller class

    def finish
      resource.processed = true
      resource.save(:validate => false)
      pointa = 0
      pointb = 0
      pointc = 0
      pointd = 0
      if resource.storage_method == "囤货"
        ids = resource.user.order_items.map(&:product_id)
        resource.order_items.each do |item|
          puts ids.to_s
          puts "product id is#{item.product.id}"
          if ids.include?(item.product.id)
             puts "ids not included"
             curr_item = resource.user.order_items.where(:product_id => item.product.id).first
             curr_item.amount += item.amount
             curr_item.save!

          else
            puts "ids  included"
            new_item = OrderItem.new(:product_id => item.product.id, :amount => item.amount)
            new_item.user_id = resource.user.id
            new_item.save!
          end
        end

      else

        resource.order_items.each do |item|
          puts "订单价格" + item.order_price.to_s
          puts "产品类别" + item.product.category.name
          cat = item.product.category.name
          if item.product.amount < item.amount
            item.product.amount = 0
          else
            item.product.amount -= item.amount
          end
            item.product.save!

          point = item.total_value.to_i
          if cat == "A类"
            puts "A类##########"
            pointa += point
          elsif cat == "B类"
            pointb += point
          elsif cat == "C类"
            pointc += point
          elsif cat == "D类"
            pointd += point
          else
          end


        end
        puts "A类########## POINTA is #{pointa}"
        if pointa > 199 && resource.user.level == "注册用户"
          resource.user.pointa += 200
          resource.user.level = "一级会员"
          Order.send_sms(resource.user.mobile)
          if resource.user.parent
            t = Time.now
            year_no = t.strftime("%Y")
            coupon = resource.user.parent.coupons.where(:year => year_no).first rescue nil
            if coupon
              coupon.follower_inc += 1
              coupon.save!
            end
          end
          puts "&&&&&&&&&&&&&&"
        else
          resource.user.pointa += pointa
        end


        resource.user.pointb += pointb
        resource.user.pointc += pointc
        resource.user.pointd += pointd
        resource.user.save!
        resource.user.record(pointa, pointb, pointc, pointd)

      end

      if resource.sent
        order_sent = Order.create
        order_sent.sn = resource.sn
        resource.order_items.each do |t|
          p_sent = OrderItem.create
          p_sent.product_id = t.product_id
          p_sent.order_price = t.order_price
          p_sent.label = t.label
          p_sent.amount = t.amount
          order_sent.order_items<<p_sent
        end
        order_sent.phone = resource.phone
        order_sent.address = resource.address
        order_sent.city = resource.city
        order_sent.province = resource.province
        order_sent.district = resource.district
        order_sent.shipment = resource.shipment
        order_sent.sent = true
        order_sent.user_id = resource.agent_id
        user = User.find(resource.agent_id)
        if user
          user.deal_sent(order_sent)
        end



        order_sent.save!

        # current_user.add_point(@cart.subtotal.to_i)

      end




      redirect_to admin_order_path(params[:id]), notice: "订单" + "已经被处理成功"
    end
  end

#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end
  menu label: "订单"

end
