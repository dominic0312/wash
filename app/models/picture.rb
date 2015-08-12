class Picture < ActiveRecord::Base
  has_attached_file :pic, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :pic, :content_type => /\Aimage\/.*\Z/
  def full_url
      "http://www.jiajiaxishangcheng.com" + self.pic.url(:original)
  end
end
