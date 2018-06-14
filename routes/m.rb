require_relative "../lib/m/operations/search_series"

class App < Roda
  route("m") do |r|
    r.is "series" do
      r.is do
        r.get do
          M::SearchSeries.call(r.params["q"], r.params["offset"])
        end
      end
    end
  end
end
