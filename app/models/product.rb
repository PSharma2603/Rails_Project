class Product < ApplicationRecord
  belongs_to :category
  has_one_attached :image

  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "description", "price", "stock_quantity", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category", "image_attachment", "image_blob"]
  end
end
