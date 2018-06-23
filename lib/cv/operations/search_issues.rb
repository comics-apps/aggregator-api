module CV
  module SearchIssues
    def self.call(volume_id)
      service = ComicVine::Api.new(ENV["COMIC_VINE_API"])
      count = service.issues(filter: "volume:#{volume_id}", limit: 1).number_of_total_results
      results = []

      0.upto(count / 100) do |i|
        offset = i * 100
        results += service.issues(filter: "volume:#{volume_id}", sort: "issue_number", offset: offset).results
      end

      results
    end
  end
end
