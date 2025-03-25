# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
AdminUser.find_or_create_by!(email: 'psharma9@rrc.ca') do |user|
    user.password = 'password'
    user.password_confirmation = 'password'
  end if Rails.env.development?
  
Category.destroy_all
Product.destroy_all

categories = %w[Smartphones Laptops Gaming SmartHome].map do |cat|
  Category.create!(name: cat)
end

10.times do
  Product.create!(
    name: Faker::Device.model_name,
    description: Faker::Lorem.sentence(word_count: 12),
    price: rand(100..2000),
    stock_quantity: rand(1..50),
    category: categories.sample
  )
end
