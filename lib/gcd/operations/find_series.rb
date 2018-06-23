module GCD
  module FindSeries
    def self.call(id)
      series = load_series(id)
      publisher = load_publisher(series)
      countries = load_countries(series, publisher)
      language = load_language(series)
      publisher[:country] = countries[publisher[:country_id]][0]
      issues = load_issues(series)

      series[:publisher] = publisher
      series[:country] = countries[series[:country_id]][0]
      series[:language] = language
      series[:issues] = issues
      GCD::SeriesPresenter.call(series)
    end

    def self.merge_data(single_series, relations, id_field, field)
      related_data = relations[single_series[id_field]][0]
      single_series[field] = related_data
      single_series
    end

    def self.load_series(id)
      DB[:gcd][:gcd_series].where(id: id).first
    end

    def self.load_publisher(series)
      DB[:gcd][:gcd_publisher].where(id: series[:publisher_id]).first
    end

    def self.load_countries(series, publisher)
      ids = [series[:country_id], publisher[:country_id]].uniq
      load_relation(:stddata_country, ids, group: true)
    end

    def self.load_language(series)
      DB[:gcd][:stddata_language].where(id: series[:language_id]).first
    end

    def self.load_issues(series)
      DB[:gcd][:gcd_issue].where(series_id: series[:id], variant_of_id: nil).to_a
    end

    def self.load_relation(relation, ids, group: false)
      data = DB[:gcd][relation].where(id: ids).to_a
      group ? group(data) : data
    end

    def self.group(data)
      data.group_by { |r| r[:id] }
    end
  end
end
