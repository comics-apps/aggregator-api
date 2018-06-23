class Caching::Marvel::SeriesList
  include Caching::Marvel::CacheSupport

  attr_reader :caching

  def initialize(caching, &block)
    @caching = caching

    instance_eval(&block)
  end

  def name
    query = caching.query["titleStartsWith"].gsub("%20", " ")
    [
      caching.uri.host,
      caching.path,
      "titleStartsWith_" + query
    ].join("/")
  end

  def cache(response)
    parse_results(response).each do |result|
      path = "marvel/series/#{caching.id_partition(result["id"])}_brief.json"
      caching.save(path, result)
    end
  end
end
