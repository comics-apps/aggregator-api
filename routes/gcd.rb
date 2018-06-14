require_relative "../lib/gcd/operations/search_series"

class App < Roda
  route("gcd") do |r|
    r.on "series" do
      r.is do
        r.get do
          GCD::SearchSeries.call(r.params["q"], r.params["offset"])
        end
      end
    end
  end
end
