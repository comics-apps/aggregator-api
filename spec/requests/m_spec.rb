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
        expect(entity.keys).to match_array(%w{country id issue_count language name publisher start_year external_url service})
        expect(entity["id"]).not_to be_nil
        expect(entity["name"]).not_to be_nil
        expect(entity["publisher"]).not_to be_nil
        expect(entity["publisher"]).to be_a(Hash)
        expect(entity["publisher"].keys).to match_array(%w(id name))
        expect(entity["publisher"]["id"]).to be_nil
        expect(entity["publisher"]["name"]).not_to be_nil
        expect(entity["start_year"]).to eql("2007")
        expect(entity["external_url"]).not_to be_nil
        expect(entity["service"]).to eql("m")

        expect(entity["country"]).to be_nil
        expect(entity["issue_count"]).to be_nil
        expect(entity["language"]).to be_nil
      end

      it "call show path" do
        VCR.use_cassette(:m_series_show) do
          get "/m/series/22413"
        end

        expect(json_body).to be_a(Hash)
        expect(json_body).not_to be_empty
        entity = json_body
        expect(entity.keys).to match_array(%w{country id issue_count language name publisher start_year external_url service issues})
        expect(entity["id"]).not_to be_nil
        expect(entity["name"]).not_to be_nil
        expect(entity["publisher"]).not_to be_nil
        expect(entity["publisher"]).to be_a(Hash)
        expect(entity["publisher"].keys).to match_array(%w(id name))
        expect(entity["publisher"]["id"]).to be_nil
        expect(entity["publisher"]["name"]).not_to be_nil
        expect(entity["start_year"]).to eql("2016")
        expect(entity["external_url"]).not_to be_nil
        expect(entity["service"]).to eql("m")
        expect(entity["issues"]).to be_an(Array)
        expect(entity["issues"]).not_to be_empty
        expect(entity["issues"][0].keys)
          .to match_array(%w(id name number external_url))

        expect(entity["country"]).to be_nil
        expect(entity["issue_count"]).to be_nil
        expect(entity["language"]).to be_nil
      end
    end
  end
end
