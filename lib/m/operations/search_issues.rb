module M
  module SearchIssues
    def self.call(series_id)
      service = Marvel::Api.new(ENV["MARVEL_PUBLIC_KEY"], ENV["MARVEL_PRIVATE_KEY"])
      count = service.comics(series: series_id, limit: 1).total

      results = []

      0.upto(count / 100) do |i|
        offset = i * 100
        p offset
        results += service.comics(series: series_id, orderBy: "issueNumber", limit: 100, offset: offset).results
      end

      results
    end
  end
end
