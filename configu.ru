require 'raffle'

run Rack::URLMap.new("/" => Site.new)