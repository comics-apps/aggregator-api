require_relative "../presenters/series_presenter"

module CDB
  module SearchSeries
    def self.call(query)
      make_request(query).map{ |el| CDB::SeriesPresenter.call(el) }
    end

    def self.make_request(query)
      conn = Faraday.new(url: ENV["CBDB_HOST"]) do |conn|
        conn.adapter(Faraday.default_adapter)
        conn.basic_auth(ENV["CBDB_BASIC_USER"], ENV["CBDB_BASIC_PASSWORD"])
      end

      response = conn.get do |req|
        req.url("/series", query: query)
      end

      JSON.parse(response.body)
    end
  end
end
