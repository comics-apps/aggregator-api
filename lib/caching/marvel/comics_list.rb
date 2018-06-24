class Caching::Marvel::ComicsList
  include Caching::Marvel::CacheSupport

  attr_reader :caching

  def initialize(caching, &block)
    @caching = caching

    instance_eval(&block)
  end

  def name
    [
      caching.uri.host,
      caching.path,
      "series_" + caching.query["series"],
      "offset_" + (caching.query["offset"] || "0"),
      caching.query["limit"].to_i == 1 ? "limit_" + caching.query["limit"] : nil
    ].compact.join("/")
  end

  def cache(response)
    parse_results(response).each do |result|
      path = "marvel/comics/#{caching.id_partition(result["id"])}_brief.json"
      caching.save(path, result)
    end
  end
end
