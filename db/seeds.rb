# Ensure required gems
require 'open-uri'
require 'httparty'

# Create admin user (only in development)
AdminUser.find_or_create_by!(email: 'psharma9@rrc.ca') do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
end if Rails.env.development?

# Create categories if not present
categories = {
  "Smartphones" => nil,
  "Laptops" => nil,
  "SmartWatches" => nil,
  "Headphones" => nil
}

categories.each_key do |cat_name|
  categories[cat_name] = Category.find_or_create_by!(name: cat_name)
end

# Create 10 products if not enough exist
if Product.count < 10
  10.times do
    Product.create!(
      name: Faker::Device.model_name,
      description: Faker::Lorem.sentence(word_count: 12),
      price: rand(100..2000),
      stock_quantity: rand(1..50),
      category: categories.values.sample
    )
  end
end

# Unsplash Service to fetch images
class UnsplashService
  include HTTParty
  base_uri "https://api.unsplash.com"

  def initialize
    @access_key = "2I-utjV34D-qHvUh1KXVy9LAaRKjZJLbIfZb2kt9gJk"
  end

  def fetch_image_url(query)
    response = self.class.get("/search/photos", query: {
      client_id: @access_key,
      query: query,
      per_page: 1
    })

    if response.success? && response["results"].any?
      response["results"][0]["urls"]["regular"]
    else
      nil
    end
  end
end

# Attach Unsplash images to products without images
unsplash = UnsplashService.new

Product.includes(:category).find_each do |product|
  next if product.image.attached?

  search_query = product.category.name
  image_url = unsplash.fetch_image_url(search_query)

  if image_url
    downloaded_image = URI.open(image_url)
    product.image.attach(io: downloaded_image, filename: "#{product.name.parameterize}.jpg")
    puts "✅ Attached image to #{product.name}"
  else
    puts "❌ No image found for #{product.name} (Category: #{search_query})"
  end
end
