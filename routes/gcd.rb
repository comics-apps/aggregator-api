require_relative "../lib/gcd/search_series"

class App < Roda
  route("gcd") do |r|
    r.on "series" do
      r.is "search" do
        GCD::SearchSeries.call(r.params["q"], r.params["offset"])
      end
    end
  end
end