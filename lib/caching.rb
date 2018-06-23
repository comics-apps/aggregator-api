class Caching
  require_relative "caching/comic_book_db"
  require_relative "caching/comic_vine"
  require_relative "caching/marvel"

  attr_reader :request, :uri, :query, :path

  def initialize(request, &block)
    @request = request
    @uri = URI(request.uri)
    @query = @uri.query.to_s.split("&").map{ |pair| pair.split("=") }.select{ |pair| pair.size == 2 }.to_h
    @path = @uri.path.gsub(/\/+$/, '')

    instance_eval(&block)
  end

  def comic_vine?(&block)
    if uri.host == "comicvine.gamespot.com"
      Caching::ComicVine.new(self, &block)
    end
  end

  def comic_book_db?(&block)
    if uri.host == ENV["CBDB_HOST"].gsub("https://", "")
      Caching::ComicBookDB.new(self, &block)
    end
  end

  def marvel?(&block)
    if uri.host == "gateway.marvel.com"
      Caching::Marvel.new(self, &block)
    end
  end

  def id_partition(id)
    ("%09d".freeze % id).scan(/\d{3}/).join("/".freeze)
  end

  def save(path, result)
    path = "tmp/cache/#{path}"
    FileUtils.mkdir_p(File.dirname(path))

    new_json = result.to_json

    if File.exist?(path)
      old_json = File.read(path)
      return if old_json == new_json
    end

    File.open(path, "w") { |f| f.write(new_json) }
  end
end
