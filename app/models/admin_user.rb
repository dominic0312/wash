class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessor :login

  def login=(login)
    @login = login
  end

  def role_name
    if self.role == "root"
      return "管理员"
    end

    if self.role == "product"
      return "产品管理"
    end

    if self.role == "order"
      return "订单管理"
    end
  end

  def login
    @login || self.mobile|| self.email
  end


  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(mobile) = :value", { :value => login.downcase }]).first
    else
      where(conditions.to_h).first
    end
  end
end
