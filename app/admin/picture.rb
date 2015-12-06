ActiveAdmin.register Picture do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
  permit_params  :id, :pic


  form do |f|
    f.inputs "图片详情" do
      f.input :pic, :required => false, :as => :file
      # Will preview the image when the object is edited
    end
    f.actions
  end



  show do |ad|
    attributes_table do
      row :id
      row :pic do
        image_tag(ad.pic.url(:thumb))
      end
      row :full_url
      # Will display the image on show object page
    end
  end


  index do
    column("编号", :id)
    column("图片", :pic) { |product| image_tag(product.pic.url(:thumb)) }
    actions
  end



  menu label: "图片", :if =>  proc{ current_admin_user.role == "product" }

end
