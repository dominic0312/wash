ActiveAdmin.register Product do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#

  filter :name
  filter :amount
  filter :price
  filter :desc


  permit_params :name, :amount, :desc, :pic, :price, :kind_id, :category_id, :storage, :pic1, :pic2, :pic3, :pic4, :pic5, :pic6, :pic7
  form do |f|
    f.inputs "产品详情" do
      f.input :name
      f.input :amount
      f.input :price
      f.input :desc
      f.input :storage

      f.input :category, :label => '分类', :as => :select, :collection => Category.all.map { |u| ["#{u.name}", u.id] },
              :include_blank => false
      # f.input :description
      f.input :kind, :label => '种类', :as => :select, :collection => Kind.all.map { |u| ["#{u.name}", u.id] },
              :include_blank => false
      # f.input :description

      f.input :pic, :required => false, :as => :file
      f.input :pic1
      f.input :pic2
      f.input :pic3
      f.input :pic4
      f.input :pic5
      f.input :pic6
      f.input :pic7


      # Will preview the image when the object is edited
    end
    f.actions
  end


  show do |ad|
    attributes_table do
      row :name
      row :amount
      row :price
      row :category, ad.category.name
      row :kind, ad.kind_name
      row :desc
      row :is_storage
      row :pic do
        image_tag(ad.pic.url(:thumb))
      end
      row :pic1 do
        if ad.pic1
         image_tag(ad.pic1)
        end
      end

      row :pic2 do
        if ad.pic2
          image_tag(ad.pic2)
        end
      end

      row :pic3 do
        if ad.pic3
          image_tag(ad.pic3)
        end
      end

      row :pic4 do
        if ad.pic4
          image_tag(ad.pic4)
        end
      end

      row :pic5 do
        if ad.pic5
          image_tag(ad.pic5)
        end
      end

      row :pic6 do
        if ad.pic6
          image_tag(ad.pic6)
        end
      end

      row :pic7 do
        if ad.pic7
          image_tag(ad.pic7)
        end
      end
      # Will display the image on show object page
    end
  end


  index do
    selectable_column
    column("名称", :sortable => :id) { |product| link_to "#{product.name} ", admin_product_path(product) }
    column("数量", :amount)
    column("价格", :price)
    column("类别", :category) {|product| link_to "#{product.category.name} ", admin_category_path(product.category)}
    column("种类", :kind)
    column("可否囤货", :is_storage)
    column("图片", :pic) { |product| image_tag(product.pic.url(:thumb)) }
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
  menu label: "产品"

end
