class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true
  belongs_to :province
end
