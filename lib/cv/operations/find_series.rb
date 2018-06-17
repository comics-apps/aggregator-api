module CV
  module FindSeries
    def self.call(id)
      service = ComicVine::Api.new(ENV["COMIC_VINE_API"])
      series = service.volume(id).results
      CV::SeriesPresenter.call(series)
    end
  end
end
