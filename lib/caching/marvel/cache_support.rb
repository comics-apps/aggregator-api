module Caching::Marvel::CacheSupport
  def parse_results(response)
    JSON.parse(response.body)["data"]["results"]
  end
end
