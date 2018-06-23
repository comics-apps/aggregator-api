class Caching::ComicBookDB::Single
  include Caching::ComicBookDB::CacheSupport

  attr_reader :caching

  def initialize(caching, &block)
    @caching = caching

    instance_eval(&block)
  end

  def name
    [caching.uri.host, caching.path].join("/")
  end

  def cache(response)
    result = parse_results(response)
    path = "comicbookdb/series/#{caching.id_partition(result["cdb_id"])}.json"
    caching.save(path, result)
  end
end
