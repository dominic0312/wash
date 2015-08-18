ActiveAdmin.register User do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#

  filter :email
  filter :mobile
  filter :address
  filter :alipay
  filter :balance


  permit_params  :email, :balance, :mobile, :address, :alipay, :uname, :pointa, :pointb, :pointc, :pointd, :level, :parent_id
  form do |f|
    f.inputs "用户详情" do
      f.input :uname
      f.input :mobile
      f.input :address
      f.input :alipay
      f.input :email
      f.input :balance
      f.input :pointa
      f.input :pointb
      f.input :pointc
      f.input :pointd

      f.input :level, :label => '级别', :as => :select, :collection => [['注册用户', '注册用户'], ['一级会员', '一级会员']],
              :include_blank => false
      f.input :parent, :label => '上级', :as => :select, :collection =>User.members.map { |u| ["#{u.mobile}", u.id] },
              :include_blank => false
      # f.input :level
    end
    f.actions
  end


  show do |ad|
    attributes_table do
      row :uname
      row :mobile
      row :balance
      row :address
      row :email
      row :alipay
      row :pass
      row :balance
      row :pointa
      row :pointb
      row :pointc
      row :pointd
      row :level
      row :parent do
        if ad.parent
          link_to ad.parent.mobile, admin_user_path(ad.parent)
        end
      end
      # Will display the image on show object page
    end
  end


  member_action :approve, method: :get do
    resource.storage = "normal"
    resource.level = "囤货商"
    resource.save(:validate => false)
    redirect_to admin_reque_path, notice: "用户"+ resource.mobile + "被批准成为囤货商"
  end


  member_action :reject, method: :get do
    resource.reject_msg = "您不满足成为囤货商的条件, 请确认后再次申请, 如有疑问, 请致电400"
    resource.storage = "rejected"
    resource.save(:validate => false)
    redirect_to admin_reque_path, notice: "用户"+ resource.mobile + "被拒绝成为囤货商"
  end



  index do
    column("姓名", :uname){|user| link_to "#{user.uname} ", user_path(user) }
    column("电话", :mobile)
    column("地址", :address)
    column("支付宝", :alipay)
    column("邮件", :sortable => :id)
    column("初始密码", :pass)
    column("余额", :balance)
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
  menu label: "用户"

end
