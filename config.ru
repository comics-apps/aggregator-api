require_relative "app"

unless ENV["RACK_ENV"] == "test"
  require "vcr"
  require "webmock"

  require_relative "lib/caching"

  VCR.configure do |c|
    c.cassette_library_dir = "./tmp/cache/"
    c.hook_into :webmock
    c.default_cassette_options = {
      match_requests_on: [:method, VCR.request_matchers.uri_without_param(:ts, :hash)]
    }

    c.around_http_request do |request|
      Caching.new(request) do
        comic_vine? do
          series_list? do
            cache(VCR.use_cassette(name, &request))
          end

          issue_list? do
            cache(VCR.use_cassette(name, &request))
          end

          series? do
            cache(VCR.use_cassette(name, &request))
          end
        end

        comic_book_db? do
          list? do
            cache(VCR.use_cassette(name, &request))
          end

          single? do
            cache(VCR.use_cassette(name, &request))
          end
        end

        marvel? do
          series_list? do
            cache(VCR.use_cassette(name, &request))
          end

          single_series? do
            cache(VCR.use_cassette(name, &request))
          end

          comics_list? do
            cache(VCR.use_cassette(name, &request))
          end
        end
      end
    end
  end

  use VCR::Middleware::Rack do |cassette|
    cassette.name     "cassette"
    cassette.options  record: :new_episodes,
                      re_record_interval: 60 * 5, # expire every 5 minutes
                      match_requests_on: [:uri]
  end
end

require "rack/cors"
use Rack::Cors do
  allow do
    origins "*"
    resource "*", headers: :any, methods: :any
  end
end

run App.freeze.app
