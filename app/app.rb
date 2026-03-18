require 'erb'
require 'json'
require_relative 'router'

class App
  def call(env)
    Router.new(env).route
  end
end
