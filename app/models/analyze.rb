class Analyze < ActiveRecord::Base
  belongs_to :user

  def is_member
    self.user.level == "一级会员" ||  self.user.level == "囤货商"
  end

  def returna
    if is_member
      if self.pointa < 1000
        return (self.pointa * 0.2).to_i
      elsif self.pointa > 1000 && self.pointa < 2000
        return (self.pointa * 0.22).to_i
      else
        return (self.pointa * 0.24).to_i
      end
    else
      return 0
    end

  end

  def returnb

    if is_member
      if self.pointb < 1000
        return 0

      else
        return (self.pointb * 0.15).to_i
      end
    else
      return 0
    end


  end

  def returnc

    if is_member
      if self.pointc < 2000
        return 0

      else
        return (self.pointc * 0.1).to_i
      end
    else
      return 0
    end


  end


end
