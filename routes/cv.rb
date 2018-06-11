require_relative "../lib/cv/search_series"

class App < Roda
  route("cv") do |r|
    r.on "series" do
      r.is "search" do
        CV::SearchSeries.call(r.params["q"], r.params["offset"])
      end
    end
  end
end
