module GCD
  module SimpleSeriesPresenter
    def self.call(entity)
      publisher = entity[:publisher] || {}
      country = entity[:country] || {}
      language = entity[:language] || {}

      {
        id: entity[:id],
        name: entity[:name],
        start_year: entity[:year_began].to_s,
        issue_count: entity[:issue_count],
        publisher: {
          id: publisher[:id],
          name: publisher[:name]
        },
        external_url: "https://www.comics.org/series/#{entity[:id]}/",
        country: country[:name],
        language: language[:name]
      }
    end
  end
end
