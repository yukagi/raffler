require './raffle'

run Raffler

map "/public" do
  run Rack::Directory.new("./public")
end