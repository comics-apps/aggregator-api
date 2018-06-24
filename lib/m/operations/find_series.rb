module M
  module FindSeries
    def self.call(id)
      service = Marvel::Api.new(ENV["MARVEL_PUBLIC_KEY"], ENV["MARVEL_PRIVATE_KEY"])
      series = service.serie(id).results[0]
      series["issues"] = M::SearchIssues.call(id)
      M::SeriesPresenter.call(series)
    end
  end
end
