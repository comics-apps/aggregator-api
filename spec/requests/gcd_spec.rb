require "request_helper"

RSpec.describe App, type: :request do
  describe "GCD" do
    describe "Series" do
      it "call search path" do
        get "/gcd/series/search", q: "foo", offset: 0

        expect(json_body).to be_an(Array)
        expect(json_body).not_to be_empty
      end
    end
  end
end
