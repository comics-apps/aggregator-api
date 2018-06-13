module CV
  module SeriesPresenter
    def self.call(entity)
      publisher = entity["publisher"] || {}

      {
        id: entity["id"],
        name: entity["name"],
        start_year: entity["start_year"],
        issue_count: entity["count_of_issues"],
        publisher: publisher["name"],
        country: nil,
        language: nil
      }
    end
  end
end
