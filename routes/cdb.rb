require_relative "../lib/cdb/presenters/series_presenter"
require_relative "../lib/cdb/presenters/simple_issue_presenter"
require_relative "../lib/cdb/presenters/simple_series_presenter"

require_relative "../lib/cdb/operations/find_series"
require_relative "../lib/cdb/operations/search_series"

class App < Roda
  route("cdb") do |r|
    r.on "series" do
      r.is do
        r.get do
          CDB::SearchSeries.call(r.params["q"])
        end
      end

      r.is :id do |id|
        r.get do
          CDB::FindSeries.call(id)
        end
      end
    end
  end
end
