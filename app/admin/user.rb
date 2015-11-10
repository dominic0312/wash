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


  permit_params :email, :balance, :mobile, :address, :alipay, :uname, :pointa, :pointb, :pointc, :pointd, :level, :parent_id, :agent_level, :brand_name
  form do |f|
    f.inputs "用户详情" do
      f.input :uname
      f.input :mobile
      f.input :address
      f.input :alipay
      f.input :email
      f.input :brand_name
      f.input :balance
      f.input :pointa
      f.input :pointb
      f.input :pointc
      f.input :pointd

      f.input :level, :label => '级别', :as => :select, :collection => [['注册用户', '注册用户'], ['一级会员', '一级会员'], ['囤货商', '囤货商']],
              :include_blank => false
      if user.level == "囤货商"
        f.input :agent_level, :label => '囤货商级别', :as => :select, :collection => [['初级', 1], ['中级', 2], ['高级', 3]],
                :include_blank => false
      end
      f.input :parent, :label => '上级', :as => :select, :collection => User.members.map { |u| ["#{u.mobile}", u.id] },
              :include_blank => false
      # f.input :level
    end
    f.actions
  end


  show do
    attributes_table do
      row :uname
      row :brand_name
      row :mobile
      row :balance
      row :address
      row :person_id
      row :province do |u|
        ChinaCity.get(u.province)
      end

      row :city do |u|
        ChinaCity.get(u.city)
      end
      row :district do |u|
        ChinaCity.get(u.district)
      end
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


    panel "下线客户列表" do

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

    panel "A类商品返点" do

      table_for user.analyzes.mon do

        column :mon
        column :pointa
        column :returna

        column :processed
        column "操作" do |child|
          if child.processed
            "无"
          else
            link_to "返点", "/payback/#{user.id}/#{child.anatype}/#{child.year}/#{child.mon}"
          end
        end

      end

    end


    panel "B类商品返点" do

      table_for user.analyzes.year do

        column :year
        column :pointb
        column :returnb

        column :processed
        column "操作" do |child|
          if child.processed
            "无"
          else
            link_to "返点", "/payback/#{user.id}/#{child.anatype}/#{child.year}/#{child.mon}"
          end
        end

      end

    end


    panel "C类商品返点" do

      table_for user.analyzes.full do


        column :pointc
        column :returnc

        column :processed
        column "操作" do |child|
          if child.processed
            "无"
          else
            link_to "返点", "/payback/#{user.id}/#{child.anatype}/#{child.year}/#{child.mon}"
          end
        end

      end

    end


    panel "会员拓展返点" do

      table_for user.coupons do
        column :year
        column :pointa
        column :returna
        column :pointb
        column :returnb
        column :pointc
        column :returnc
        column :follower_inc
        column :processed
        column "操作" do |child|
          if child.processed || child.follower_inc < 10
            "无"
          else
            link_to "返点", "/paycoupon/#{user.id}/#{child.year}"
          end
        end

      end

    end


    panel "囤货库存" do

      table_for user.order_items do

        column "名称" do |child|
          child.product.name
        end
        column "数量" do |child|
          child.amount
        end

      end

    end


  end


  member_action :approve, method: :get do
    resource.storage = "empty"
    resource.level = "囤货商"
    resource.save(:validate => false)
    redirect_to admin_reque_path, notice: "用户"+ resource.mobile + "被批准成为囤货商"
  end


  member_action :reject, method: :get do
    resource.reject_msg = "您提交的信息不满足成为囤货商的条件"
    resource.storage = "rejected"
    resource.save(:validate => false)
    redirect_to admin_reque_path, notice: "用户"+ resource.mobile + "被拒绝成为囤货商"
  end


  index do
    column("姓名", :uname) { |user| link_to "#{user.uname} ", admin_user_path(user) }
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

    def paycoupon
      coupon = Coupon.where(:user_id => params[:uid], :year => params[:year]).first
      u = User.find(params[:uid].to_i)
      if coupon
        u.balance += (coupon.returna + coupon.returnb + coupon.returnc)
        coupon.processed = true
        coupon.save!
        u.save!
      end

      redirect_to admin_user_path(params[:uid]), notice: "客户拓展提成" + "已经被处理成功"
    end


    def payback
      analyze = Analyze.where(:user_id => params[:uid], :anatype => params[:anatype], :mon => params[:mon], :year => params[:year]).first
      u = User.find(params[:uid].to_i)
      t = Time.now

      year_no = t.strftime("%Y")

      coupon = Coupon.where(:user_id => params[:uid], :year => year_no).first

      if !coupon
        coupon = Coupon.new(:user_id => params[:uid], :year => year_no, :pointa => 0, :pointb => 0, :pointc => 0)
        # coupon.follower = u.children.size
      end


      if analyze

        if analyze.anatype == "month"
          u.balance += analyze.returna
          coupon.pointa += (analyze.pointa - analyze.returna)
          analyze.processed = true
        end

        if analyze.anatype == "year"
          u.balance += analyze.returnb
          coupon.pointb += (analyze.pointb - analyze.returnb)
          analyze.processed = true
        end

        if analyze.anatype == "all"
          u.balance += analyze.returnc
          coupon.pointc += (analyze.pointc - analyze.returnc)
          oldrec = Analyze.new(:user_id => params[:uid], :year => 'year', :mon => 'mon', :pointa => 0, :pointb => 0, :pointc => analyze.pointc, :anatype => 'all', :processed => true)
          oldrec.save!
          analyze.pointc = 0
        end

        u.save!
        analyze.save!
        coupon.save!
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
