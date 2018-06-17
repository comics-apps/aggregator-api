require_relative "../lib/gcd/presenters/series_presenter"
require_relative "../lib/gcd/presenters/simple_issue_presenter"
require_relative "../lib/gcd/presenters/simple_series_presenter"

require_relative "../lib/gcd/operations/find_series"
require_relative "../lib/gcd/operations/search_series"

class App < Roda
  route("gcd") do |r|
    r.on "series" do
      r.is do
        r.get do
          GCD::SearchSeries.call(r.params["q"], r.params["offset"])
        end
      end

      r.is :id do |id|
        r.get do
          GCD::FindSeries.call(id)
        end
      end
    end
  end
end
