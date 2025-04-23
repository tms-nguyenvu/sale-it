# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


['admin', 'sale_support'].each do |role_name|
  Role.find_or_create_by(name: role_name)
end


admin = User.create_with(
  password: 'Hoangvu200202@',
  password_confirmation: 'Hoangvu200202@',
  username: 'tms-nguyenvu',
  first_name: 'Nguyen',
  last_name: 'Hoang Vu'
).find_or_create_by(email: 'admin@example.com')


admin.add_role :admin unless admin.has_role? :admin



sale_support = User.create_with(
  password: 'Hoangvu200202@',
  password_confirmation: 'Hoangvu200202@',
  username: 'tms-giang',
  first_name: 'Giang',
  last_name: 'Nguyen'
).find_or_create_by(email: 'sale_support@example.com')

sale_support.add_role :sale_support unless sale_support.has_role? :sale_support
