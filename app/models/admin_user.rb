class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessor :login

  def login=(login)
    @login = login
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
