require 'bcrypt'
require_relative '../utils/database'

class User
  COLLECTION = :users

  attr_accessor :id, :email, :password_hash, :name

  def self.authenticate(email, password)
    user_data = Database.collection(COLLECTION).find(email: email).first
    return nil unless user_data

    user = from_hash(user_data)
    BCrypt::Password.new(user.password_hash) == password ? user : nil
  end

  def self.create(attrs)
    attrs[:password_hash] = BCrypt::Password.create(attrs[:password])
    attrs.delete(:password)
    Database.collection(COLLECTION).insert_one(attrs)
  end

  def self.from_hash(hash)
    user = new
    user.id = hash['_id']
    user.email = hash['email']
    user.password_hash = hash['password_hash']
    user.name = hash['name']
    user
  end
end
