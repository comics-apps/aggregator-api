require "comic_vine/api"
require "dotenv"
require "faraday"
require "marvel/api"
require "roda"

ENV["RACK_ENV"] ||= "develop"
Dotenv.load(".env.#{ENV["RACK_ENV"]}", ".env")

require_relative "lib/database_setup"

class App < Roda
  plugin :all_verbs
  plugin :halt
  plugin :json
  plugin :multi_route

  require_relative "routes/cv"
  require_relative "routes/gcd"
  require_relative "routes/m"
  require_relative "routes/cdb"
  require_relative "routes/aggregates"

  route do |r|
    r.multi_route

    r.on "cv" do
      r.route "cv"
    end

    r.on "gcd" do
      r.route "gcd"
    end

    r.on "m" do
      r.route "m"
    end

    r.on "cdb" do
      r.route "cdb"
    end

    r.on "aggregates" do
      r.routes "aggregates"
    end

    r.root do
      { status: "OK" }
    end
  end
end
