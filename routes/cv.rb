require_relative "../lib/cv/presenters/series_presenter"
require_relative "../lib/cv/presenters/simple_issue_presenter"
require_relative "../lib/cv/presenters/simple_series_presenter"

require_relative "../lib/cv/operations/find_series"
require_relative "../lib/cv/operations/search_series"

class App < Roda
  route("cv") do |r|
    r.on "series" do
      r.is do
        r.get do
          CV::SearchSeries.call(r.params["q"], r.params["offset"])
        end
      end

      r.is :id do |id|
        r.get do
          CV::FindSeries.call(id)
        end
      end
    end
  end
end
