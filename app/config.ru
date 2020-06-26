$stdout.sync = true
$stderr.sync = true

unless ENV['NO_PROMETHEUS']
  require 'prometheus/middleware/collector'
  require 'prometheus/middleware/exporter'
  use Prometheus::Middleware::Collector
  use Prometheus::Middleware::Exporter
end

unless ENV['NO_IMAGE_PULLS']
  command = "ruby #{__dir__}/src/pull.rb > /tmp/startup.pull.log &"
  system(command)
end

require_relative 'src/rack_dispatcher'
require 'rack'
dispatcher = RackDispatcher.new(Rack::Request)
run dispatcher
