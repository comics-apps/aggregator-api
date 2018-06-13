require "request_helper"

RSpec.describe App, type: :request do
  describe "CDB" do
    describe "Series" do
      it "call search path" do
        VCR.use_cassette(:cdb_series_search) do
          get "/cdb/series/search", q: "foo"
        end

        expect(json_body).to be_an(Array)
        expect(json_body).not_to be_empty
      end
    end
  end
end
