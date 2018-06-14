require_relative "../lib/cv/operations/search_series"

class App < Roda
  route("cv") do |r|
    r.on "series" do
      r.is do
        r.get do
          CV::SearchSeries.call(r.params["q"], r.params["offset"])
        end
      end
    end
  end
end
