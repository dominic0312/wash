class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]

  attr_accessor :login, :promotion_address, :promotion

  has_many :orders, dependent: :destroy
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


  def init_password
    puts 'here in init'
    if !self.password && !self.password_confirmation && !self.id
      random_pass = rand(32**8).to_s(32)
      self.pass = random_pass
      self.password = self.password_confirmation= random_pass
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


  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(mobile) = :value", {:value => login.downcase}]).first
    else
      where(conditions.to_h).first
    end
  end
end
