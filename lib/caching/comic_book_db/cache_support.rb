module Caching::ComicBookDB::CacheSupport
  def parse_results(response)
    JSON.parse(response.body)
  end
end
