require "sequel"

DB = {
  gcd: Sequel.connect(ENV["GCD_DATABASE"], adapter: :mysql2),
  aggregation: Sequel.connect(ENV["AGGREGATION_DATABASE"], adapter: :mysql2),
}
