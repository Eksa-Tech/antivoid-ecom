require 'jwt'

module AuthHelper
  SECRET = ENV['JWT_SECRET'] || 'yoursecret'

  def self.encode_token(payload)
    JWT.encode(payload, SECRET)
  end

  def self.decode_token(token)
    JWT.decode(token, SECRET)[0]
  rescue
    nil
  end

  def self.authenticated?(req)
    token = req.cookies['auth_token']
    return false unless token

    payload = decode_token(token)
    payload && payload['user_id']
  end

  def self.current_user(req)
    token = req.cookies['auth_token']
    return nil unless token

    payload = decode_token(token)
    return nil unless payload && payload['user_id']

    User.find(payload['user_id'])
  end

  def self.admin?(req)
    user = current_user(req)
    user && user.role == 'admin'
  end
end
