class Caching::ComicBookDB
  require_relative "comic_book_db/cache_support"
  require_relative "comic_book_db/list"
  require_relative "comic_book_db/single"

  attr_reader :caching

  def initialize(caching, &block)
    @caching = caching

    instance_eval(&block)
  end

  def list?(&block)
    if caching.query.keys.include?("query")
      Caching::ComicBookDB::List.new(caching, &block)
    end
  end

  def single?(&block)
    unless caching.query.keys.include?("query")
      Caching::ComicBookDB::Single.new(caching, &block)
    end
  end
end
