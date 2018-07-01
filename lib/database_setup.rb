require "sequel"

DB = {
  gcd: Sequel.connect(ENV["GCD_DATABASE"], adapter: :mysql2)
}
