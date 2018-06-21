require_relative "app"

unless ENV["RACK_ENV"] == "test"
  require "vcr"
  require "webmock"

  VCR.configure do |c|
    c.cassette_library_dir = "./tmp/cache/"
    c.hook_into :webmock
    c.default_cassette_options = {
      match_requests_on: [:method, VCR.request_matchers.uri_without_param(:ts, :hash)]
    }

    c.around_http_request do |request|
      uri = URI(request.uri)
      query = uri.query.to_s.split("&").map{ |pair| pair.split("=") }.select{ |pair| pair.size == 2 }.to_h
      path = uri.path.gsub(/\/+$/, '')

      if uri.host == "comicvine.gamespot.com"
        if query.keys.include?("filter")
          filter = query["filter"].split(":")
          name = "#{[uri.host, path, "filter_" + filter.last.gsub("%20", " ")].join('/')}"
          VCR.use_cassette(name, &request)
        else
          name = "#{[uri.host, path].join('/')}"
          VCR.use_cassette(name, &request)
        end

      elsif uri.host == ENV["CBDB_HOST"].gsub("https://", "")
        if query.keys.include?("query")
          query = query["query"].gsub("%20", " ")
          name = "#{[uri.host, path, "query_" + query].join('/')}"
          VCR.use_cassette(name, &request)
        else
          name = "#{[uri.host, path].join('/')}"
          VCR.use_cassette(name, &request)
        end

      elsif uri.host == "gateway.marvel.com"
        if query.keys.include?("titleStartsWith")
          query = query["titleStartsWith"].gsub("%20", " ")
          name = "#{[uri.host, path, "titleStartsWith_" + query].join('/')}"
          VCR.use_cassette(name, &request)
        elsif query.keys.include?("series")
          name = "#{[uri.host, path, "series_" + query["series"], "offset_" + (query["offset"] || "0") ].join('/')}"
          VCR.use_cassette(name, &request)
        else
          name = "#{[uri.host, path].join('/')}"
          VCR.use_cassette(name, &request)
        end

      else
        name = "#{[uri.host, uri.path, request.method].join('/')}"
        VCR.use_cassette(name, &request)
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
