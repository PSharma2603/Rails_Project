# app/models/order_item.rb
class OrderItem < ApplicationRecord
  belongs_to :order, inverse_of: :order_items
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price_at_purchase, presence: true
end
