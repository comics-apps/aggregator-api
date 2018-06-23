module CDB
  module SimpleSeriesPresenter
    def self.call(entity)
      {
        id: entity["cdb_id"],
        name: entity["name"],
        start_year: entity["start_date"].to_s.match(/\d+/),
        issue_count: nil,
        publisher: {
          id: entity["publisher_id"],
          name: entity["publisher_name"]
        },
        external_url: "http://www.comicbookdb.com/title.php?ID=#{entity["cdb_id"]}",
        country: nil,
        language: nil,
        service: "cdb"
      }
    end
  end
end
