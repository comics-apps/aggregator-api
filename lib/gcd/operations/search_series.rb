module GCD
  module SearchSeries
    def self.call(query, offset)
      series = load_series(query, offset)
      publishers = load_publishers(series)
      countries = load_countries(series, publishers)
      languages = load_languages(series)

      publishers = publishers.each do |p|
        country = countries[p[:country_id]][0]
        p[:country] = country
      end.group_by { |r| r[:id] }

      series.each do |s|
        merge_data(s, publishers, :publisher_id, :publisher)
        merge_data(s, countries, :country_id, :country)
        merge_data(s, languages, :language_id, :language)
      end.map{ |el| GCD::SimpleSeriesPresenter.call(el) }
    end

    def self.merge_data(single_series, relations, id_field, field)
      related_data = relations[single_series[id_field]][0]
      single_series[field] = related_data
    end

    def self.load_series(query, offset)
      DB[:gcd_series]
        .where(Sequel.like(Sequel.function(:lower, :name), "%#{query}%"))
        .limit(100).offset(offset).to_a
    end

    def self.load_publishers(series)
      ids = series.map{ |s| s[:publisher_id] }.uniq
      load_relation(:gcd_publisher, ids)
    end

    def self.load_countries(series, publishers)
      ids = (series + publishers).map{ |d| d[:country_id] }.uniq
      load_relation(:stddata_country, ids, group: true)
    end

    def self.load_languages(series)
      ids = series.map{ |s| s[:language_id] }.uniq
      load_relation(:stddata_language, ids, group: true)
    end

    def self.load_relation(relation, ids, group: false)
      data = DB[relation].where(id: ids).to_a
      group ? group(data) : data
    end

    def self.group(data)
      data.group_by { |r| r[:id] }
    end
  end
end
