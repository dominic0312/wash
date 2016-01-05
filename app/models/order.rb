class Order < ActiveRecord::Base
 belongs_to :user
 has_one :charge
 has_many :order_items,dependent: :destroy
 scope :recent, ->(size) { limit(size).order(created_at: :desc)}
 scope :stored, -> { where(storage: true) }
 scope :unprocessed, -> { where(processed: false) }
 scope :unpaid, -> { where(paid: false) }
 scope :paid, -> { where(paid: true, processed: false) }
 scope :history, -> { where(processed: true) }
 scope :normal, -> { where(storage: false) }
 scope :sent, -> { where(sent:true, agent_id: nil) }
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

 def send_type
   self.sent ? "送货" : "发货"
 end

 def paid_status
   self.paid ? "已付款" : "未付款"
 end

 def ship_fee
   self.shipment ? "￥#{self.shipment}" : "未定"
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



 def Order.send_sms(mobile)
   message = "尊敬的用户, 您已经在家家商城升级为会员, 您可以享受家家商城的会员优惠和返利。,
    请登录 www.jiajiaxishangcheng.com 来购物.【家家商城】"
   uri = URI('https://sms-api.luosimao.com/v1/send.json')
   Net::HTTP.start(uri.host, uri.port,
                   :use_ssl => uri.scheme == 'https',
                   :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

     request = Net::HTTP::Post.new uri.path
     # mobile2='13590296140'
     data = {'mobile' => mobile, 'cb' => 'callback', 'message' => message}
     request.form_data = data
     request.basic_auth 'api', '618b92cc656f8e532bb2c08a0d8d205a'
     response = http.request request # Net::HTTPResponse object
     puts response
     puts response.body
   end
 end

end
