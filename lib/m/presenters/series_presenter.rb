module M
  module SeriesPresenter
    def self.call(entity)
      {
        id: entity["id"],
        name: entity["title"],
        start_year: entity["startYear"].to_s,
        issue_count: nil,
        publisher: "Marvel",
        country: nil,
        language: nil
      }
    end
  end
end
