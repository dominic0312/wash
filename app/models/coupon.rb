class Coupon < ActiveRecord::Base
  belongs_to :user


  def is_valid
    self.user.level == "一级会员" && self.follower_inc > 9
  end

  def returna
     if is_valid
        (self.pointa * 0.08).round
     else
       0
     end

  end

  def returnb
    if is_valid
      (self.pointb * 0.06).round
    else
      0
    end
  end


  def returnc
    if is_valid
      (self.pointc * 0.04).round
    else
      0
    end
  end
end
