require "request_helper"

RSpec.describe App, type: :request do
  it "call root path" do
    get "/"

    expect(json_body).to eql({ "status" => "OK" })
  end
end
