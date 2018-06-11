class App < Roda
  plugin :json
  plugin :multi_route

  require_relative "routes/cv"

  route do |r|
    r.multi_route

    r.on "cv" do
      r.route "cv"
    end

    r.root do
      { status: "OK" }
    end
  end
end
