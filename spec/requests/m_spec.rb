require "request_helper"

RSpec.describe App, type: :request do
  describe "M" do
    describe "Series" do
      it "call search path" do
        VCR.use_cassette(:m_series_search) do
          get "/m/series/search", q: "foo", offset: 0
        end

        body = json_body

        expect(body).to be_an(Array)
        expect(body).not_to be_empty
      end
    end
  end
end
