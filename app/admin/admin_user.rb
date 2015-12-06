ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation, :role

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :role_name
    actions
  end



  show do
    attributes_table do
      row :email
      row :role_name
      row :sign_in_count
      row :current_sign_in_at
      row :last_sign_in_at

    end
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "管理员信息" do
      f.input :email
      f.input :role, :label => '角色', :as => :select, :collection => [['管理员', 'root'], ['产品管理', 'product'], ['订单管理', 'order']],
              :include_blank => false
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  menu label: "管理员", :if =>  proc{ current_admin_user.role == "root" }

end
