ActiveAdmin.register Product do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#

  filter :name
  filter :amount
  filter :price
  filter :desc


  permit_params :name, :amount, :desc, :pic, :price, :category_id, :storage
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

      f.input :pic, :required => false, :as => :file
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
      row :desc
      row :is_storage
      row :pic do
        image_tag(ad.pic.url(:thumb))
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
    column("说明", :desc)
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
