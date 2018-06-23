require_relative "../lib/aggregation/operations/create"
require_relative "../lib/aggregation/operations/delete"
require_relative "../lib/aggregation/operations/find_all"

class App < Roda
  route("aggregates") do |r|
    r.is do
      r.get do
        Aggregation::FindAll.call(r.params)
      end

      r.post do
        response.status = 201
        Aggregation::Create.call(
          cv_id: r.params["cv_id"],
          gcd_id: r.params["gcd_id"],
          cdb_id: r.params["cdb_id"],
          m_id: r.params["m_id"]
        )
      end
    end

    r.is :id do |id|
      r.delete do
        Aggregation::Delete.call(id)
        r.halt 204
      end
    end
  end
end
