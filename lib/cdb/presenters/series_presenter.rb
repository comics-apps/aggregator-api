module CDB
  module SeriesPresenter
    def self.call(entity)
      CDB::SimpleSeriesPresenter.call(entity).tap do |h|
        h[:issues] = entity["issues"]
                       .map{ |i| CDB::SimpleIssuePresenter.call(i) }
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
