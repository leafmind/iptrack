# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# User api key
user_api_key = ApiKey.create!(token: 'USR1', role: 0)

# Admin api key
admin_api_key = ApiKey.create!(token: 'ADM1', role: 1)

Geocode.create!(api_key: admin_api_key, target: '1.1.1.1', city: 'City0', country: 'Country')
Geocode.create!(api_key: user_api_key, target: '8.8.8.8', city: 'City1', country: 'Country')
Geocode.create!(api_key: user_api_key, target: '8.8.4.4', city: 'City2', country: 'Country')