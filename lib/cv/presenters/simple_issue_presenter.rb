module CV
  module SimpleIssuePresenter
    def self.call(entity)
      {
        id: entity["id"],
        name: entity["name"],
        number: entity["issue_number"],
        external_url: entity["site_detail_url"]
      }
    end
  end
end
