class Product < ActiveRecord::Base
  belongs_to :category
  belongs_to :kind
  belongs_to :provider
  has_many :order_items, dependent: :destroy
  has_many :sub_products, dependent: :destroy
  accepts_nested_attributes_for :sub_products, :allow_destroy => true
  # after_initialize :set_default_category
  has_attached_file :pic, :styles => {:medium => "300x300>", :thumb => "100x100>"}, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :pic, :content_type => /\Aimage\/.*\Z/

  def self.process_cart(cart)
    results=[]
    cart.cart_items.each do |t|
      product = Product.find(t.item.id)

      if product.amount < t.quantity
        puts "商品#{product.name}的库存不足, 购买失败"
        result = "商品***#{product.name}***的库存不足, 购买失败"
        results<<result
        # product.amount -= t.quantity
        # product.save!
        # puts "商品#{product.name}购买成功"
        # return "success"
      end


    end


    if results==[]
      cart.cart_items.each do |t|
        product = Product.find(t.item.id)
        product.amount -= t.quantity
        product.save!
        puts "商品#{product.name}购买成功"

      end
      return "success"
    else
      return results
    end
  end


  def discount
    if self.category
      if self.category.discount
       return  self.category.discount
      else
        return 100
      end
    else
      return 100
    end
  end

  def kind_name
    if self.kind
      self.kind.name
    else
      "无"
    end
  end

  def provider_name
    if self.provider
      self.provider.name
    else
      "无"
    end
  end


  def member_price
    if self.category
      if self.category.discount
        return (self.price * self.category.discount).round / 100.0
      else
        return self.price
      end
    else
      return self.price
    end
  end


  def is_storage
    self.storage ? "可" : "否"
  end

  def member_status
    self.is_member ? "是" : "否"
  end

  protected
  # def set_default_category
  #   self.category = Category.first()
  # end
end
