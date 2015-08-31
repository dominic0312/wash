class Site < ActiveRecord::Base


  def Site.account
    if Site.first
      return Site.first.account1
    else
      return "建行 8888 8888 8888  王麻子"
    end
  end
end
