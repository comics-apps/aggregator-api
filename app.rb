require "dotenv"
require "roda"

ENV["RACK_ENV"] ||= "develop"
Dotenv.load(".env.#{ENV["RACK_ENV"]}", ".env")

class App < Roda
  plugin :json

  route do |r|
    r.root do
      { status: "OK" }
    end
  end
end
