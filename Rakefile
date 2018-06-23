namespace :db do
  task :migrate do
    require_relative "app"

    Sequel.extension :migration
    Sequel::Migrator.run(DB[:aggregation], "db/migrations", use_transactions: true)
  end
end
