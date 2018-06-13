require "comic_vine/api"
require "dotenv"
require "faraday"
require "marvel/api"
require "roda"

Dotenv.load

require_relative "lib/database_setup"
require_relative "app"

run App.freeze.app
