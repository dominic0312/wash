class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]

  attr_accessor :login, :promotion_address, :promotion

  has_many :orders, dependent: :destroy
  has_many :analyzes, dependent: :destroy
  has_many :coupons, dependent: :destroy
  has_many :order_items
  has_many :children, class_name: "User",
           foreign_key: "parent_id"

  belongs_to :parent, class_name: "User"
  scope :requested, -> { where(storage: "request") }
  scope :members, -> { where("pointa > 199") }

  validates_uniqueness_of :mobile
  validates_presence_of :mobile


  before_create :init_username, :init_promotion
  before_validation :init_password

  def email_required?
    false
  end

  def promotion_address
    return "http://www.jiajiaxishangcheng.com/promotion/" + self.promotion_code
  end


  def init_username
    puts 'here in init name'
    self.username = self.mobile if self.mobile != ""
  end

  def process_cart(cart)
    results = [];
    ids = self.order_items.map(&:product_id)

    cart.cart_items.each do |t|
      product = Product.find(t.item.id)
      result = self.process_store(product, t.quantity, ids)
      if result == "less"
        puts "商品#{product.name}在此囤货商处数量不够, 购买失败"
        results << "商品**#{product.name}**在此囤货商处数量不够, 购买失败"
      end
    end
    puts results.to_s
    if results == []
      puts "EMPTY LIST"
      # cart.cart_items.each do |t|
      #   curr_item = self.order_items.where(:product_id => t.item.id).first
      #   curr_item.amount -= t.quantity
      #   curr_item.save!
      # end
     return "success"
    else
      puts "NOT EMPTY LIST"
      return results
    end
  end

  def process_store(product, amount, ids)

    puts ids.to_s
    puts "product id is#{product.id}"
    if ids.include?(product.id)
      puts "ids not included"
      curr_item = self.order_items.where(:product_id => product.id).first
      if curr_item.amount < amount
        return "less"
      else

      # curr_item.amount -= amount
      # curr_item.save!
      end
    else
      return "less"
    end
  end


  def deal_sent(order)
      order.order_items.each do |t|
        curr_item = self.order_items.where(:product_id => t.product_id).first
        if curr_item.amount < t.amount
          curr_item.amount = 0
        else
          curr_item.amount = curr_item.amount - t.amount

        end

        curr_item.save!
        end
  end





  def init_password
    puts 'here in init'
    if !self.password && !self.password_confirmation && !self.id
      random_pass = rand(32**8).to_s(32)
      self.pass = random_pass
      self.password = self.password_confirmation = random_pass
      puts "current password is:" + self.password
    end
  end

  def init_promotion
    if self.promotion
      puts "it has promotion" + self.promotion
      u = User.where(promotion_code: self.promotion)
      self.parent = u.first
      self.source = "introduce"
    end
    self.promotion_code = rand(32**8).to_s(32)
  end


  def name
    return self.email
  end

  def add_point(point)
    if self.point < 200 && self.point + point > 200
      self.level = "会员"
      if self.parent
        if self.source == "introduce"
          self.parent.balance += 60;
          self.parent.save(:validate => false)
        elsif self.source == "input"
          self.parent.balance += 90;
          self.parent.save(:validate => false)
        end
      end
    end

    self.point += point

  end


  def agent_level_cn
    if self.agent_level == 3
      "高级"
    elsif self.agent_level ==2
      "中级"
    else
      "初级"
    end
  end

  def promotion=(promotion)
    @promotion = promotion
  end

  def promotion
    @promotion
  end

  def login=(login)
    @login = login
  end

  def login
    @login || self.mobile || self.email
  end


  def record(pota, potb, potc, potd)
    t = Time.now
    mon_no = t.strftime("%Y%m")
    year_no = t.strftime("%Y")
    recmon = Analyze.where(:user_id => self.id, :mon => mon_no, :anatype => 'month').first
    recyear = Analyze.where(:user_id => self.id, :year => year_no, :anatype => 'year').first
    recall = Analyze.where(:user_id => self.id, :anatype => 'all').first

    coupon = Coupon.where(:user_id => self.id, :year => year_no).first

    if !coupon
      coupon = Coupon.new(:user_id => self.id, :year => year_no, :pointa => 0, :pointb => 0, :pointc => 0 )
    end


    if !recmon
      recmon = Analyze.new(:user_id => self.id, :mon => mon_no, :year => 'year', :pointa => 0, :pointb => 0, :pointc => 0, :pointd => 0, :anatype => 'month')
    end

    if !recyear
      recyear = Analyze.new(:user_id => self.id, :year => year_no, :mon => 'mon', :pointa => 0, :pointb => 0, :pointc => 0, :pointd => 0, :anatype => 'year')
    end

    if !recall
      recall = Analyze.new(:user_id => self.id,  :year => 'year', :mon => 'mon', :pointa => 0, :pointb => 0, :pointc => 0, :pointd => 0, :anatype => 'all')
    end




    recmon.pointa += pota
    recyear.pointb += potb
    recall.pointc += potc

    recmon.save!
    recyear.save!
    recall.save!
    coupon.save!

  end


  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(mobile) = :value", {:value => login.downcase}]).first
    else
      where(conditions.to_h).first
    end
  end
end
