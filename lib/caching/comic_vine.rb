class Caching::ComicVine
  require_relative "comic_vine/cache_support"
  require_relative "comic_vine/issue_list"
  require_relative "comic_vine/series"
  require_relative "comic_vine/series_list"

  attr_reader :caching

  def initialize(caching, &block)
    @caching = caching

    instance_eval(&block)
  end

  def series_list?(&block)
    if caching.uri.path == "/api/volumes/"
      Caching::ComicVine::SeriesList.new(caching, &block)
    end
  end

  def issue_list?(&block)
    if caching.uri.path == "/api/issues/"
      Caching::ComicVine::IssueList.new(caching, &block)
    end
  end

  def series?(&block)
    if caching.uri.path.match("/api/volume/")
      Caching::ComicVine::Series.new(caching, &block)
    end
  end
end
