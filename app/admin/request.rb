ActiveAdmin.register_page "Reque" do
  menu priority: 10, label: proc{ "囤货申请" }

  content title: proc{ "囤货审批" } do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
      column do
        panel "申请列表" do
          table_for User.requested.order('id desc') do
            column("电话") {|user| link_to(user.mobile, admin_user_path(user.id))                                   }
            column("姓名"){|user| user.uname }
            column("级别")   {|user| user.level }
            column("余额")   {|user| user.balance }
            column("积分")   {|user| user.point }
            column("注册时间")   {|user| user.created_at }
            column("申请时间")   {|user| user.updated_at }
            column("")   {|user| link_to('通过', approve_admin_user_path(user.id))  }
            column("")   {|user| link_to('驳回', reject_admin_user_path(user.id))  }



          end

        end
      end

      #   column do
      #     panel "Info" do
      #       para "Welcome to ActiveAdmin."
      #     end
      #   end
    end
  end # content
end