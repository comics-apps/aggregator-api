module Aggregation
  module FindAll
    def self.call(params)
      filter = params.fetch("filter", {})
      field = prepare_query_field(filter["service"])
      issues = DB[:aggregation][:issues].where(field => filter["ids"].split(",")).all

      cv_issues = load_cv_issues(issues)
      gcd_issues = load_gcd_issues(issues)
      cdb_issues = load_cdb_issues(issues)
      m_issues = load_m_issues(issues)

      issues.map do |issue|
        issue.tap do |h|
          h[:cv_issue] = cv_issues[h[:cv_id]][0]
          h[:gcd_issue] = gcd_issues[h[:gcd_id]][0]
          h[:cdb_issue] = cdb_issues[h[:cdb_id]][0]
          h[:m_issue] = m_issues[h[:m_id]][0]
        end
      end
    end

    def self.prepare_query_field(service)
      case service
        when "cv" then :cv_id
        when "gcd" then :gcd_id
        when "cdb" then :cdb_id
        when "m" then :m_id
        else raise NotImplementedError
      end
    end

    def self.id_partition(id)
      ("%09d".freeze % id).scan(/\d{3}/).join("/".freeze)
    end

    def self.load_cv_issues(issues)
      issues.map do |issue|
        next unless issue[:cv_id]
        id = id_partition(issue[:cv_id])
        issue = JSON.parse(File.read("tmp/cache/comicvine/issues/#{id}_brief.json"))
        CV::SimpleIssuePresenter.call(issue).merge(service: "cv")
      end.group_by { |issue| issue[:id] }
    end

    def self.load_gcd_issues(issues)
      ids = issues.map{ |i| i[:gcd_id] }.compact
      DB[:gcd][:gcd_issue].where(id: ids).all.map do |issue|
        GCD::SimpleIssuePresenter.call(issue).merge(service: "gcd")
      end.group_by { |issue| issue[:id] }
    end

    def self.load_cdb_issues(issues)
      issues.map do |issue|
        next unless issue[:cdb_id]
        id = id_partition(issue[:cdb_id])
        issue = JSON.parse(File.read("tmp/cache/comicbookdb/issues/#{id}_brief.json"))
        CDB::SimpleIssuePresenter.call(issue).merge(service: "cdb")
      end.group_by { |issue| issue[:id] }
    end

    def self.load_m_issues(issues)
      issues.map do |issue|
        next unless issue[:m_id]
        id = id_partition(issue[:m_id])
        issue = JSON.parse(File.read("tmp/cache/marvel/comics/#{id}_brief.json"))
        M::SimpleIssuePresenter.call(issue).merge(service: "m")
      end.group_by { |issue| issue[:id] }
    end
  end
end
