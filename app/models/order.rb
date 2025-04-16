class Order < ApplicationRecord
  belongs_to :user, optional: true
  has_many :order_items, inverse_of: :order, dependent: :destroy
  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address

  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
