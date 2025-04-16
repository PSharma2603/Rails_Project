class Province < ApplicationRecord
    has_many :addresses
    has_many :users

    validates :gst, :pst, :hst, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
end
