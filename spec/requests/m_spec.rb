require "request_helper"

RSpec.describe App, type: :request do
  describe "M" do
    describe "Series" do
      it "call index path" do
        VCR.use_cassette(:m_series_index) do
          get "/m/series", q: "foo", offset: 0
        end

        expect(json_body).to be_an(Array)
        expect(json_body).not_to be_empty
        entity = json_body[0]
        expect(entity.keys).to match_array(%w{country id issue_count language name publisher start_year external_url})
        expect(entity["id"]).not_to be_nil
        expect(entity["name"]).not_to be_nil
        expect(entity["publisher"]).not_to be_nil
        expect(entity["publisher"]).to be_a(Hash)
        expect(entity["publisher"].keys).to match_array(%w(id name))
        expect(entity["publisher"]["id"]).to be_nil
        expect(entity["publisher"]["name"]).not_to be_nil
        expect(entity["start_year"]).not_to be_nil
        expect(entity["start_year"]).to be_a(String)
        expect(entity["external_url"]).not_to be_nil

        expect(entity["country"]).to be_nil
        expect(entity["issue_count"]).to be_nil
        expect(entity["language"]).to be_nil
      end
    end
  end
end
