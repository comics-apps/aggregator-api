module Caching::ComicVine::CacheSupport
  def parse_results(response)
    JSON.parse(response.body)["results"]
  end
end
