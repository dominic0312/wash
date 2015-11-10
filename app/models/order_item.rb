class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  belongs_to :user
  scope :recent, ->(size) { limit(size).order(created_at: :desc)}

  def total_value
    self.order_price * self.amount
  end
end