class Caching::Marvel::SingleSeries
  include Caching::Marvel::CacheSupport

  attr_reader :caching

  def initialize(caching, &block)
    @caching = caching

    instance_eval(&block)
  end

  def name
    [caching.uri.host, caching.path].join("/")
  end

  def cache(response)
    result = parse_results(response)[0]
    path = "marvel/series/#{caching.id_partition(result["id"])}.json"
    caching.save(path, result)
  end
end
