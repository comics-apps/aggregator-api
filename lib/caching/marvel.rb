class Caching::Marvel
  require_relative "marvel/cache_support"
  require_relative "marvel/series_list"
  require_relative "marvel/comics_list"
  require_relative "marvel/single_series"

  attr_reader :caching

  def initialize(caching, &block)
    @caching = caching

    instance_eval(&block)
  end

  def series_list?(&block)
    if caching.query.keys.include?("titleStartsWith")
      Caching::Marvel::SeriesList.new(caching, &block)
    end
  end

  def comics_list?(&block)
    if caching.query.keys.include?("series")
      Caching::Marvel::ComicsList.new(caching, &block)
    end
  end

  def single_series?(&block)
    keys = caching.query.keys
    if !keys.include?("titleStartsWith") && !keys.include?("series")
      Caching::Marvel::SingleSeries.new(caching, &block)
    end
  end
end
