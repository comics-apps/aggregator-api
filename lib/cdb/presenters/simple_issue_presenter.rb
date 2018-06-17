module CDB
  module SimpleIssuePresenter
    def self.call(entity)
      {
        id: entity["cdb_id"],
        name: entity["name"],
        number: entity["num"],
        external_url: "http://www.comicbookdb.com/issue.php?ID=#{entity["cdb_id"]}"
      }
    end
  end
end
