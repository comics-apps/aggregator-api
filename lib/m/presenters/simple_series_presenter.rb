module M
  module SimpleSeriesPresenter
    def self.call(entity)
      url_data = entity["urls"].select{|el| el["type"] == "detail" }[0]
      url = url_data ? url_data["url"].split("?")[0] : ""

      {
        id: entity["id"],
        name: entity["title"],
        start_year: entity["startYear"].to_s,
        issue_count: nil,
        publisher: {
          id: nil,
          name: "Marvel"
        },
        external_url: url,
        country: nil,
        language: nil,
        service: "m"
      }
    end
  end
end
