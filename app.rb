class App < Roda
  plugin :json

  route do |r|
    r.root do
      { status: "OK" }
    end
  end
end
