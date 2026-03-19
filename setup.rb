require_relative 'app/models/user'
require 'dotenv/load'

Dotenv.load

def seed_admin
  email = ENV['ADMIN_EMAIL'] || 'admin@example.com'
  password = ENV['ADMIN_PASSWORD'] || 'password123'

  existing_user = Database.collection(User::COLLECTION).find(email: email).first
  if existing_user
    puts "Admin user already exists: #{email}"
  else
    User.create(
      email: email,
      password: password,
      name: 'Global Admin',
      role: 'admin'
    )
    puts "Admin user created: #{email} / #{password}"
  end
rescue StandardError => e
  puts "Error seeding admin: #{e.message}"
end

seed_admin
