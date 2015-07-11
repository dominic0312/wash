ActiveAdmin.register Order do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#


  filter :storage
  filter :processed
  # filter :desc


  permit_params :processed, :storage
  form do |f|
    f.inputs "订单状态" do
      f.input :processed
    end
    f.actions
  end


  show do |ad|
    attributes_table do
      row "客户姓名" do
        ad.user.uname
      end

      row "客户手机" do
        ad.user.mobile
      end

      row "是否囤货" do
        ad.is_storage
      end

      row "是否处理" do
        ad.is_processed
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

    attributes_table do
      ad.order_items.each do |item|
        row "产品名称" do
          item.product.name
        end

        row "产品数量" do
          item.amount
        end

        row "产品总价" do
          item.totalvalue
        end



      end
    end

  end


  index do
    selectable_column
    column("客户", :sortable => :id) { |order| link_to "#{order.user.mobile} ", admin_user_path(order.user) }
    column("下单时间") { |order| order.created_at }
    column("是否囤货") { |order| order.is_storage }
    column("处理状况") { |order| order.is_processed }
    column("查看详情") { |order| link_to "查看", admin_order_path(order)}
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
