ActiveAdmin.register Site do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
  #
  # filter :name
  # filter :amount
  # filter :price
  # filter :desc


  permit_params :account1, :account2, :alipay
  form do |f|
    f.inputs "网站账号" do
      f.input :account1
      f.input :alipay
 # Will preview the image when the object is edited
    end
    f.actions
  end





  index do

    column("账号", :account1)
    column("支付宝(可为空)", :alipay)

    actions
  end

#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end
  menu label: "账户", :if =>  proc{ current_admin_user.role == "root" }

end
