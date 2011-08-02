require 'raffle'

run Rack::URLMap.new("/" => Raffler.new)