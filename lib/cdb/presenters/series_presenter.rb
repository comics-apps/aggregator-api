module CDB
  module SeriesPresenter
    def self.call(entity)
      {
        id: entity["cdb_id"],
        name: entity["name"],
        start_year: entity["start_date"],
        issue_count: nil,
        publisher: {
          id: nil,
          name: entity["publisher"]
        },
        external_url: "http://www.comicbookdb.com/title.php?ID=#{entity["cdb_id"]}",
        country: nil,
        language: nil
      }
    end
  end
end
