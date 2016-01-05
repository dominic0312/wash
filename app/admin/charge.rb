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

  show do |ad|
    attributes_table do

      row "流水号" do
        ad.sn
      end

      row "金额" do
        ad.amount

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


end
