class Order < ActiveRecord::Base
 belongs_to :user
 has_many :order_items,dependent: :destroy
 scope :recent, ->(size) { limit(size).order(created_at: :desc)}
 scope :stored, -> { where(storage: true) }
 before_create :init_sn

 def init_sn
   self.sn = "JJX" + Time.now.to_formatted_s(:number)

 end

 def is_storage
   self.storage ? "可" : "否"
 end

 def is_processed
   self.processed ? "已处理" : "未处理"
 end

 def full_address
   addr = ""
   if self.province
     addr = addr + ChinaCity.get(self.province)
   end

   if self.city
     addr = addr + ChinaCity.get(self.city)
   end

   if self.district
     addr = addr + ChinaCity.get(self.district)
   end

   if self.address
     addr = addr + self.address
   end

   return addr
 end


 def total_value
   t_value = 0
   self.order_items.each do |it|
     t_value += it.total_value
   end
   return t_value
 end

end
