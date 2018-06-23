module Aggregation
  module Delete
    def self.call(id)
      DB[:aggregation][:issues].where(id: id).delete
    end
  end
end
