module CDB
  module FindSeries
    def self.call(id)
      CDB::SeriesPresenter.call(make_request(id))
    end

    def self.make_request(id)
      conn = Faraday.new(url: ENV["CBDB_HOST"]) do |conn|
        conn.adapter(Faraday.default_adapter)
        conn.basic_auth(ENV["CBDB_BASIC_USER"], ENV["CBDB_BASIC_PASSWORD"])
      end

      response = conn.get do |req|
        req.url("/series/#{id}")
      end

      JSON.parse(response.body)
    end
  end
end
