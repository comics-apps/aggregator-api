module CV
  module SeriesPresenter
    def self.call(entity)
      CV::SimpleSeriesPresenter.call(entity).tap do |h|
        h[:issues] = entity["issues"]
                       .map{ |i| CV::SimpleIssuePresenter.call(i) }
                       .sort_by{ |i| i[:number].to_i }
      end
    end
  end
end
