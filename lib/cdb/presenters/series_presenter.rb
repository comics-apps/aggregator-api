module CDB
  module SeriesPresenter
    def self.call(entity)
      {
        id: entity["cdb_id"],
        name: entity["name"],
        start_year: entity["start_date"],
        issue_count: nil,
        publisher: entity["publisher"],
        country: nil,
        language: nil
      }
    end
  end
end
