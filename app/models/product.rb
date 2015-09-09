class Product < ActiveRecord::Base
  belongs_to :category
  belongs_to :kind
  has_many :order_items, dependent: :destroy
  # after_initialize :set_default_category
  has_attached_file :pic, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :pic, :content_type => /\Aimage\/.*\Z/

  def self.process_cart(cart)
    cart.cart_items.each do |t|
      product = Product.find(t.item.id)
      product.amount -= t.quantity
      product.save!
    end
  end

  def kind_name
    if self.kind
      self.kind.name
    else
      "无"
    end
  end


  def is_storage
    self.storage ? "可" : "否"
  end

  protected
    # def set_default_category
    #   self.category = Category.first()
    # end
end
