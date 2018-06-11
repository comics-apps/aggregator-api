module CDB
  module SearchSeries
    def self.call(query)
      CDB::Series.search(query, proxy: ENV["PROXY"])
    end
  end
end
