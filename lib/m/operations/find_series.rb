module M
  module FindSeries
    def self.call(id)
      service = Marvel::Api.new(ENV["MARVEL_PUBLIC_KEY"], ENV["MARVEL_PRIVATE_KEY"])
      series = service.serie(id).results[0]
      issues = service.comics(series: 2029, orderBy: "issueNumber", limit: 100).results
      series["issues"] = issues
      M::SeriesPresenter.call(series)
    end
  end
end
