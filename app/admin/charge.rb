ActiveAdmin.register Charge do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end
  actions :index, :show

  filter :sn
  filter :finished
  filter :created_at
  filter :updated_at
  filter :chr_type
  filter :amount

  show do |ad|
    attributes_table do

      row "流水号" do
        ad.sn
      end

      row "金额" do
        ad.amount

      end

      row "类型" do
        ad.chr_type

      end


      row "客户姓名" do
        ad.user.uname
      end

      row "客户手机" do
        link_to "#{ad.user.mobile}", admin_user_path(ad.user)

      end

      row "支付时间" do
        ad.updated_at

      end

      row "相关订单" do
        if ad.chr_type == "购物"
          link_to "#{ad.order.sn}", "/admin/orders/#{ad.order.id}"
        else
          "无相关订单"
        end

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

  menu label: "充值记录", :if =>  proc{ current_admin_user.role == "order" ||  current_admin_user.role == "root" }
end