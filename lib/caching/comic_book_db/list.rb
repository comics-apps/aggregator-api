class Caching::ComicBookDB::List
  include Caching::ComicBookDB::CacheSupport

  attr_reader :caching

  def initialize(caching, &block)
    @caching = caching

    instance_eval(&block)
  end

  def name
    query = caching.query["query"].gsub("%20", " ")
    [
      caching.uri.host,
      caching.path,
      "query_" + query
    ].join("/")
  end

  def cache(response)
    parse_results(response).each do |result|
      path = "comicbookdb/series/#{caching.id_partition(result["cdb_id"])}_brief.json"
      caching.save(path, result)
    end
  end
end
