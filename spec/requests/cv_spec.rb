require "request_helper"

RSpec.describe App, type: :request do
  describe "CV" do
    describe "Series" do
      it "call search path" do
        VCR.use_cassette(:cv_series_search) do
          get "/cv/series/search", q: "foo", offset: 0
        end

        expect(json_body).to be_an(Array)
        expect(json_body).not_to be_empty
      end
    end
  end
end
