class Order < ActiveRecord::Base
 belongs_to :user
 has_many :order_items,dependent: :destroy
 scope :recent, ->(size) { limit(size).order(created_at: :desc)}
 scope :stored, -> { where(storage: true) }

 def is_storage
   self.storage ? "可" : "否"
 end

 def is_processed
   self.processed ? "已处理" : "未处理"
 end

end
