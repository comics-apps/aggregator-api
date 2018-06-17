module M
  module SimpleIssuePresenter
    def self.call(entity)
      url_data = entity["urls"].select{|el| el["type"] == "detail" }[0]
      url = url_data ? url_data["url"].split("?")[0] : ""

      {
        id: entity["id"],
        name: entity["title"],
        number: entity["issueNumber"],
        external_url: url,
      }
    end
  end
end
