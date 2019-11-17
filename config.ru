$stdout.sync = true
$stderr.sync = true

require 'rack'
use Rack::Deflater, if: ->(_, _, _, body) { body.any? && body[0].length > 512 }

unless ENV['NO_PROMETHEUS']
  require 'prometheus/middleware/collector'
  require 'prometheus/middleware/exporter'
  metrics_prefix = ENV['PROMETHEUS_COLLECTOR_METRICS_PREFIX'] || 'http_server'
  use(Prometheus::Middleware::Collector, { metrics_prefix:metrics_prefix })
  use Prometheus::Middleware::Exporter
end

require_relative 'src/rack_dispatcher'
dispatcher = RackDispatcher.new(Rack::Request)
run dispatcher
