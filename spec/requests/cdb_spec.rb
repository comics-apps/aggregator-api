require "request_helper"

RSpec.describe App, type: :request do
  describe "CDB" do
    describe "Series" do
      it "call index path" do
        VCR.use_cassette(:cdb_series_index) do
          get "/cdb/series", q: "foo"
        end

        expect(json_body).to be_an(Array)
        expect(json_body).not_to be_empty
        entity = json_body[0]
        expect(entity.keys).to match_array(%w{country id issue_count language name publisher start_year})
        expect(entity["id"]).not_to be_nil
        expect(entity["name"]).not_to be_nil
        expect(entity["publisher"]).not_to be_nil
        expect(entity["publisher"]).to be_a(Hash)
        expect(entity["publisher"].keys).to match_array(%w(id name))
        expect(entity["publisher"]["id"]).to be_nil
        expect(entity["publisher"]["name"]).not_to be_nil
        expect(entity["start_year"]).not_to be_nil
        expect(entity["start_year"]).to be_a(String)

        expect(entity["country"]).to be_nil
        expect(entity["issue_count"]).to be_nil
        expect(entity["language"]).to be_nil
      end
    end
  end
end
