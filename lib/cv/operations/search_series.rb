module CV
  module SearchSeries
    def self.call(query, offset)
      service = ComicVine::Api.new(ENV["COMIC_VINE_API"])
      service
        .volumes(filter: "name:#{query}", offset: offset)
        .results
        .map{ |el| CV::SimpleSeriesPresenter.call(el) }
    end
  end
end
