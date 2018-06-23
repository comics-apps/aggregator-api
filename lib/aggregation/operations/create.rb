module Aggregation
  module Create
    def self.call(ids)
      content = {
        cv_id: ids[:cv_id],
        gcd_id: ids[:gcd_id],
        cdb_id: ids[:cdb_id],
        m_id: ids[:m_id]
      }

      id = DB[:aggregation][:issues].insert(content)

      content.tap do |h|
        h[:id] = id
      end
    end
  end
end
