require "rack/test"

require_relative "support/json"

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

def app
  App.app
end
