class Caching::ComicVine
  require_relative "comic_vine/cache_support"
  require_relative "comic_vine/list"
  require_relative "comic_vine/single"

  attr_reader :caching

  def initialize(caching, &block)
    @caching = caching

    instance_eval(&block)
  end

  def list?(&block)
    if caching.query.keys.include?("filter")
      Caching::ComicVine::List.new(caching, &block)
    end
  end

  def single?(&block)
    unless caching.query.keys.include?("filter")
      Caching::ComicVine::Single.new(caching, &block)
    end
  end
end
