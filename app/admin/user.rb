ActiveAdmin.register User do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#

  filter :email
  filter :mobile
  filter :address
  filter :alipay
  filter :balance
  filter :level


  permit_params  :email, :balance, :mobile, :address, :alipay, :uname, :pointa, :pointb, :pointc, :pointd, :level, :parent_id, :agent_level
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

      f.input :level, :label => '级别', :as => :select, :collection => [['注册用户', '注册用户'], ['一级会员', '一级会员'], ['囤货商', '囤货商']],
              :include_blank => false
      if user.level == "囤货商"
        f.input :agent_level, :label => '囤货商级别', :as => :select, :collection => [['一级', 1], ['二级', 2],['三级', 3]],
                :include_blank => false
      end
      f.input :parent, :label => '上级', :as => :select, :collection =>User.members.map { |u| ["#{u.mobile}", u.id] },
              :include_blank => false
      # f.input :level
    end
    f.actions
  end


  show do
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
      if user.level == "囤货商"
        row :agent_level
      end

      # row :代理级别 do |ad|
      #   if ad.level == "囤货商"
      #     ad.agent_level
      #   else
      #     "无"
      #   end
      # end
      row :parent do |ad|
        if ad.parent
          link_to ad.parent.mobile, admin_user_path(ad.parent)
        end
      end

      row "通知用户" do |ad|
        button_to "通知#{ad.mobile}", "/notice/" + ad.id.to_s, remote: true
      end






      # Will display the image on show object page
    end

    div do

      table_for user.children do
        column :id
        column :mobile do |child|
          link_to "#{child.mobile} ", admin_user_path(child)
        end
        column :uname
        column :pointa
        column :pointb
        column :pointc
        column :pointd
        column :created_at


      end
      # if user.children.size > 0
      #   user.children.each do |c|
      #     link_to "下级", admin_user_path(user)
      #   end
      # else
      #   "0"
      # end
    end

    div do

      table_for user.analyzes do

        column :mon
        column :pointa
        column :returna
        column :pointb
        column :returnb
        column :pointc
        column :returnc
        column :processed
        column "操作" do |child|
          if child.processed
            "无"
          else
            link_to "返点", "/payback/#{user.id}/#{child.mon}"
          end
        end




      end
      # if user.children.size > 0
      #   user.children.each do |c|
      #     link_to "下级", admin_user_path(user)
      #   end
      # else
      #   "0"
      # end
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
    column("姓名", :uname){|user| link_to "#{user.uname} ", admin_user_path(user) }
    column("级别", :level)
    column("电话", :mobile)
    column("地址", :address)
    column("邮件", :sortable => :id)
    column("初始密码", :pass)
    column("余额", :balance)
    actions
  end



  controller do
    # This code is evaluated within the controller class

    def payback
      analyze = Analyze.where(:user_id => params[:uid], :mon => params[:mon]).first
      if analyze
         u = User.find(params[:uid].to_i)
         point = analyze.returna + analyze.returnb + analyze.returnc
         u.balance += point
         u.save!
         analyze.processed = true
         analyze.save!
         # puts "helloworld + #{u.balance}"
      end
      # resource.processed = true
      redirect_to admin_user_path(params[:uid]), notice: "付款" + "已经被处理成功"
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
  menu label: "用户"

end
