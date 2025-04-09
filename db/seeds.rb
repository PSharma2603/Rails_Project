# Ensure required gems
require 'open-uri'
require 'httparty'

# Create admin user (only in development)
if Rails.env.development?
  AdminUser.find_or_create_by!(email: 'psharma9@rrc.ca') do |user|
    user.password = 'password'
    user.password_confirmation = 'password'
  end
end

# Create categories if not present
category_names = ["Smartphones", "Laptops", "SmartWatches", "Headphones"]
categories = {}

category_names.each do |name|
  categories[name] = Category.find_or_create_by!(name: name)
end

# Seed provinces only if none exist
if Province.count == 0
  Province.create!([
    { name: 'Alberta', gst: 0.05, pst: 0.0, hst: 0.0 },
    { name: 'British Columbia', gst: 0.05, pst: 0.07, hst: 0.0 },
    { name: 'Manitoba', gst: 0.05, pst: 0.07, hst: 0.0 },
    { name: 'New Brunswick', gst: 0.0, pst: 0.0, hst: 0.15 },
    { name: 'Newfoundland and Labrador', gst: 0.0, pst: 0.0, hst: 0.15 },
    { name: 'Nova Scotia', gst: 0.0, pst: 0.0, hst: 0.15 },
    { name: 'Ontario', gst: 0.0, pst: 0.0, hst: 0.13 },
    { name: 'Prince Edward Island', gst: 0.0, pst: 0.0, hst: 0.15 },
    { name: 'Quebec', gst: 0.05, pst: 0.09975, hst: 0.0 },
    { name: 'Saskatchewan', gst: 0.05, pst: 0.06, hst: 0.0 }
  ])
  puts "✅ Provinces seeded"
else
  puts "➡️ Provinces already seeded"
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
  puts "✅ Products seeded"
else
  puts "➡️ Products already present"
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
