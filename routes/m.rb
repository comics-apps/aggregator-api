require_relative "../lib/m/operations/search_series"

class App < Roda
  route("m") do |r|
    r.on "series" do
      r.is "search" do
        M::SearchSeries.call(r.params["q"], r.params["offset"])
      end
    end
  end
end
