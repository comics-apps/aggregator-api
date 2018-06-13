require_relative "../lib/cdb/operations/search_series"

class App < Roda
  route("cdb") do |r|
    r.on "series" do
      r.is "search" do
        CDB::SearchSeries.call(r.params["q"])
      end
    end
  end
end
