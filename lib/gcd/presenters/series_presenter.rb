module GCD
  module SeriesPresenter
    def self.call(entity)
      GCD::SimpleSeriesPresenter.call(entity).tap do |h|
        h[:issues] = entity[:issues]
                       .map{ |i| GCD::SimpleIssuePresenter.call(i) }
                       .sort_by do |i|

          begin
            Integer(i[:number]).to_s.rjust(4, "0")
          rescue
            i[:number]
          end
        end
      end
    end
  end
end
