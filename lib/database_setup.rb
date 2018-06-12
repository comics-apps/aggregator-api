require "sequel"

DB = Sequel.connect(ENV["GCD_DATABASE"], adapter: :mysql2)
