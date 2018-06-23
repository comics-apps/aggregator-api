class Caching::ComicVine::List
  include Caching::ComicVine::CacheSupport

  attr_reader :caching

  def initialize(caching, &block)
    @caching = caching

    instance_eval(&block)
  end

  def name
    filter = caching.query["filter"].split(":")
    [
      caching.uri.host,
      caching.path,
      "filter_" + filter.last.gsub("%20", " ")
    ].join("/")
  end

  def cache(response)
    parse_results(response).each do |result|
      path = "comicvine/series/#{caching.id_partition(result["id"])}_brief.json"
      caching.save(path, result)
    end
  end
end
