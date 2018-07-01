namespace :db do
  task :migrate do
    require_relative "app"

    Sequel.extension :migration
    Sequel::Migrator.run(DB[:aggregation], "db/migrations", use_transactions: true)
  end
end

namespace :stats do
  def partition(id)
    ("%06d".freeze % id).scan(/\d{2}/).join("/".freeze)
  end

  def try_again(&block)
    begin
      retries ||= 0
      puts "try ##{ retries }" if retries > 0
      block.call
    rescue => e
      if (retries += 1) < 3
        retry
      else
        raise e
      end
    end
  end

  task :cv, [:publisher_name] do |_task, args|
    require "json"

    series = []

    files = Dir.glob("tmp/stats/cv/#{args[:publisher_name]}/volumes/**/*.json")
    files.each do |path|
      volume = JSON.parse(File.read(path))

      series << { id: volume["id"], name: volume["name"], issue_count: volume["count_of_issues"], start_year: volume["start_year"] }
    end

    series.sort_by { |obj| [obj[:issue_count], obj[:start_year].to_i, obj[:name]] }.each do |obj|
      puts "#{obj[:name]} (#{obj[:start_year]}) [#{obj[:issue_count]}]"
    end
  end

  namespace :cv do
    task :fetch, [:publisher_id] do |_task, args|
      exit unless args[:publisher_id]

      require "dotenv"
      Dotenv.load

      require "comic_vine/api"
      service = ComicVine::Api.new(ENV["COMIC_VINE_API"])

      puts "Fetching publisher..."
      publisher = service.publisher(args[:publisher_id]).results
      volumes = publisher["volumes"]
      volume_ids = volumes.map{ |v| v["id"] }
      volume_count = volume_ids.size
      publisher_name = publisher["name"].downcase

      puts "Publisher: #{publisher["name"]}"
      puts "Volume count: #{volume_count}"

      i = 0
      sleep(1)
      volume_ids.each do |volume_id|
        i += 1
        next if i < 2929
        response = service.volume(volume_id)
        puts
        count_from_issues = response.results["issues"] ? response.results["issues"].size : 0
        puts "#{i}/#{volume_count} #{response.results["name"]} (issue count: #{response.results["count_of_issues"]}|#{count_from_issues})"

        no = partition(response.results["id"])
        path = "tmp/stats/cv/#{publisher_name}/volumes/#{no}.json"
        FileUtils.mkdir_p(File.dirname(path))
        File.open(path, "wb") do |f|
          f.write(response.results.to_json)
        end

        # issues
        puts "Fetching issues..."
        response_i = service.issues(limit: 100, filter: "volume:#{response.results["id"]}")
        total = response_i.number_of_total_results
        puts "Total issues: #{total}"
        path = "tmp/stats/cv/#{publisher_name}/issues/#{no}"
        FileUtils.mkdir_p(path)
        if total > 100
          0.upto(total / 100) do |p|
            offset = p * 100
            puts "offset: #{offset}"
            sleep(1)
            response_i = service.issues(limit: 100, filter: "volume:#{response.results["id"]}", offset: offset, sort: "id")

            File.open("#{path}/issues_#{p.to_s.rjust(2, "0")}.json", "wb") do |f|
              f.write(response_i.results.to_json)
            end
          end
        else
          File.open("#{path}/issues.json", "wb") do |f|
            f.write(response_i.results.to_json)
          end
        end
      end
    end
  end

  task :cdb, [:publisher_name] do |_task, args|
    require "json"

    series = []

    files = Dir.glob("tmp/stats/cdb/#{args[:publisher_name]}/series/**/*.json")
    files.each do |path|
      volume = JSON.parse(File.read(path))

      series << { id: volume["cdb_id"], name: volume["name"], issue_count: volume["issues"].size, start_year: volume["start_date"].scan(/\d+/)[0] }
    end

    series.sort_by { |obj| [obj[:issue_count], obj[:start_year].to_i, obj[:name]] }.each do |obj|
      puts "#{obj[:name]} (#{obj[:start_year]}) [#{obj[:issue_count]}]"
    end
  end

  namespace :cdb do
    task :fetch, [:publisher_id] do |_task, args|
      exit unless args[:publisher_id]

      require "dotenv"
      Dotenv.load

      require "faraday"
      require "json"

      conn = Faraday.new(url: ENV["CBDB_HOST"]) do |conn|
        conn.adapter(Faraday.default_adapter)
        conn.basic_auth(ENV["CBDB_BASIC_USER"], ENV["CBDB_BASIC_PASSWORD"])
      end

      puts "Fetching publisher..."
      response = conn.get do |req|
        req.url("/publishers/#{args[:publisher_id]}")
      end

      publisher = JSON.parse(response.body)
      series_count = publisher["series"].count
      publisher_name = publisher["name"].downcase
      puts "Publisher: #{publisher["name"]}"
      puts "Volume count: #{series_count}"

      i = 0
      publisher["series"].each do |series|
        i += 1

        response2 = conn.get do |req|
          req.url("/series/#{series["cdb_id"]}")
        end

        series = JSON.parse(response2.body)

        puts
        puts "#{i}/#{series_count} #{series["name"]} (issue count: #{series["issues"].size})"

        no = partition(series["cdb_id"])
        path = "tmp/stats/cdb/#{publisher_name}/series/#{no}.json"
        FileUtils.mkdir_p(File.dirname(path))
        File.open(path, "wb") do |f|
          f.write(series.to_json)
        end
      end
    end
  end

  namespace :marvel do
    task :fetch do
      require "dotenv"
      Dotenv.load

      require "digest"
      require "json"
      require "marvel/api"

      save = ->(response, offset, total, kind) {
        path_part = partition(offset / 100)

        path = "tmp/stats/marvelcom/marvel/#{kind}/#{path_part}.json"
        FileUtils.mkdir_p(File.dirname(path))
        File.open(path, "wb") do |f|
          f.write(response.results.to_json)
        end
      }

      service = Marvel::Api.new(ENV["MARVEL_PUBLIC_KEY"], ENV["MARVEL_PRIVATE_KEY"])
      response = try_again { service.series(orderBy: "startYear,title", limit: 100) }
      total = response.total
      puts "Series count: #{total}"

      save.call(response, 0, total, "series")


      1.upto(total / 100) do |p|
        offset = p * 100

        puts
        puts "series offset: #{offset}"

        response = try_again { service.series(orderBy: "startYear,title", limit: 100, offset: offset) }
        save.call(response, offset, total, "series")
      end


      response = try_again { service.comics(orderBy: "focDate,onsaleDate,title,issueNumber", limit: 100) }
      total = response.total
      puts "Issue count: #{total}"
      save.call(response, 0, total, "comics")

      1.upto(total / 100) do |p|
        offset = p * 100

        puts
        puts "comics offset: #{offset}"

        response = try_again { service.comics(orderBy: "focDate,onsaleDate,title,issueNumber", limit: 100, offset: offset) }
        save.call(response, offset, total, "comics")
      end
    end
  end
end
