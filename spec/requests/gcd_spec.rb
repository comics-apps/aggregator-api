require "request_helper"

RSpec.describe App, type: :request do
  describe "GCD" do
    describe "Series" do
      it "call index path" do
        get "/gcd/series", q: "foo", offset: 0

        expect(json_body).to be_an(Array)
        expect(json_body).not_to be_empty
        entity = json_body[0]
        expect(entity.keys).to match_array(%w{country id issue_count language name publisher start_year})
        expect(entity["country"]).not_to be_nil
        expect(entity["id"]).not_to be_nil
        expect(entity["issue_count"]).not_to be_nil
        expect(entity["language"]).not_to be_nil
        expect(entity["name"]).not_to be_nil
        expect(entity["publisher"]).not_to be_nil
        expect(entity["publisher"]).to be_a(Hash)
        expect(entity["publisher"].keys).to match_array(%w(id name))
        expect(entity["publisher"]["id"]).not_to be_nil
        expect(entity["publisher"]["name"]).not_to be_nil
        expect(entity["start_year"]).not_to be_nil
        expect(entity["start_year"]).to be_a(String)
      end
    end
  end
end
