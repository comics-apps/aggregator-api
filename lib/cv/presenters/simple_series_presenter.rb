module CV
  module SimpleSeriesPresenter
    def self.call(entity)
      publisher = entity["publisher"] || {}

      {
        id: entity["id"],
        name: entity["name"],
        start_year: entity["start_year"],
        issue_count: entity["count_of_issues"],
        publisher: {
          id: publisher["id"],
          name: publisher["name"]
        },
        external_url: entity["site_detail_url"],
        country: nil,
        language: nil
      }
    end
  end
end
