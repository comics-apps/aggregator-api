module GCD
  module SimpleIssuePresenter
    def self.call(entity)
      {
        id: entity[:id],
        name: entity[:title],
        number: entity[:number],
        external_url: "https://www.comics.org/issue/#{entity[:id]}/",
      }
    end
  end
end
