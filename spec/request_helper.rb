require "rack/test"
require "vcr"

require_relative "support/json"

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.default_cassette_options = {
    record: ENV["RECORDING"] ? :all : :none,
    match_requests_on: [:method, VCR.request_matchers.uri_without_param(:ts, :hash)]
  }
  config.filter_sensitive_data('<API_KEY>') { ENV["COMIC_VINE_API"] }
  config.filter_sensitive_data('<PUBLIC_KEY>') { ENV["MARVEL_PUBLIC_KEY"] }
  config.filter_sensitive_data('<BASIC_AUTH>') { Base64.encode64("#{ENV["CBDB_BASIC_USER"]}:#{ENV["CBDB_BASIC_PASSWORD"]}").chomp }
  config.before_record do |i|
    i.response.body.force_encoding('UTF-8')
  end
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

def app
  App.app
end
