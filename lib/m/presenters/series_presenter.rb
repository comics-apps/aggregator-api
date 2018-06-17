module M
  module SeriesPresenter
    def self.call(entity)
      M::SimpleSeriesPresenter.call(entity).tap do |h|
        h[:issues] = entity["issues"].map{ |i| M::SimpleIssuePresenter.call(i) }
      end
    end
  end
end
