ActiveAdmin.register Provider do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
  permit_params  :name

  menu label: "厂商", :if =>  proc{ current_admin_user.role == "product" || current_admin_user.role == "root" }



end
