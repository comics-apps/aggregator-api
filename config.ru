require "comic_vine/api"
require "dotenv"
require "marvel/api"
require "roda"

Dotenv.load

require_relative "app"

run App.freeze.app
