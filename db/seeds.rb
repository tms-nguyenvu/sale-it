[ 'admin', 'sale_support' ].each do |role_name|
   Role.find_or_create_by(name: role_name)
 end


 admin = User.create_with(
   password: 'Hoangvu200202@',
   password_confirmation: 'Hoangvu200202@',
 ).find_or_create_by(email: 'admin@example.com')


 admin.add_role :admin unless admin.has_role? :admin



 sale_support = User.create_with(
   password: 'Hoangvu200202@',
   password_confirmation: 'Hoangvu200202@',
 ).find_or_create_by(email: 'sale_support@example.com')

 sale_support.add_role :sale_support unless sale_support.has_role? :sale_support
