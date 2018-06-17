require_relative "../lib/m/presenters/series_presenter"
require_relative "../lib/m/presenters/simple_issue_presenter"
require_relative "../lib/m/presenters/simple_series_presenter"

require_relative "../lib/m/operations/find_series"
require_relative "../lib/m/operations/search_series"

class App < Roda
  route("m") do |r|
    r.on "series" do
      r.is do
        r.get do
          M::SearchSeries.call(r.params["q"], r.params["offset"])
        end
      end

      r.is :id do |id|
        r.get do
          M::FindSeries.call(id)
        end
      end
    end
  end
end
