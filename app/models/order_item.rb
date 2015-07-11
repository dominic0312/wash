class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  scope :recent, ->(size) { limit(size).order(created_at: :desc)}
end