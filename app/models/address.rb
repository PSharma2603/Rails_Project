class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true
  belongs_to :province


  validates :postal_code, format: { with: /\A[\w\s-]+\z/, message: "only allows letters, numbers, and spaces" }
end
