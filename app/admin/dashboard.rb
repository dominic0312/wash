ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    # Here is an example of a simple dashboard with columns and panels.
    #

    panel "最新未处理订单" do

      table_for Order.recent(20).unprocessed do
        # column "" do |item|
        #   link_to "#{item.product.name} ", admin_product_path(item.product)
        # end


        column "订单编号" do |item|
          link_to "#{item.sn} ", admin_order_path(item.id)
        end

        column "客户名称" do |item|
          item.user.brand_name
        end

        column "客户手机" do |item|
          link_to "#{item.user.mobile} ", admin_user_path(item.user)
        end

        column "是否囤货" do |item|
          item.is_storage
        end

        column "发送方式" do |item|
          item.send_type
        end

        column "下单时间" do |item|
          item.created_at.strftime("%Y-%m-%d %H:%M:%S" )
        end

        column "处理状态" do |item|
          item.is_processed
        end



        # column :pointb
        # column :pointc
        # column :pointd
        # column :created_at


      end

    end



  end # content
end
