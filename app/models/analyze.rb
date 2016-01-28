class Analyze < ActiveRecord::Base
  belongs_to :user
  scope :mon, -> { where(anatype: 'month') }
  scope :year, -> { where(anatype: 'year') }
  scope :full, -> { where(anatype: 'all') }

  def is_member
    self.user.level == "一级会员"
  end

  def returna
    if is_member
      pointa = self.pointa - 200
      if pointa < 0
        return 0 
      end
      if pointa < 1000
        return (pointa * 0.2).to_i
      elsif pointa > 1000 && pointa < 2000
        return (pointa * 0.22).to_i
      else
        return (pointa * 0.24).to_i
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
        return ((self.pointb - 1000) * 0.15).to_i
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
        return ((self.pointc - 2000) * 0.1).to_i
      end
    else
      return 0
    end


  end


end
