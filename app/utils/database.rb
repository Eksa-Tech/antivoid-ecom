require 'mongo'
require 'dotenv/load'

module Database
  class << self
    def client
      @client ||= Mongo::Client.new(ENV['MONGODB_URI'] || 'mongodb://127.0.0.1:27017/ruby_e-commerce_db')
    end

    def collection(name)
      client[name]
    end
  end
end
