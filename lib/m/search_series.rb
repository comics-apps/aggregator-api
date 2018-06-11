module M
  module SearchSeries
    def self.call(query, offset)
      service = Marvel::Api.new(ENV["MARVEL_PUBLIC_KEY"], ENV["MARVEL_PRIVATE_KEY"])
      service.series(titleStartsWith: query, offset: offset).results
    end
  end
end
