# require 'prometheus/client/rack/collector'
# require 'prometheus/client/rack/exporter'
# Rails.application.config.middleware.use Prometheus::Client::Rack::Collector
# Rails.application.config.middleware.use Prometheus::Client::Rack::Exporterrequire 'prometheus/middleware/collector'
require 'prometheus/middleware/collector'
require 'prometheus/middleware/exporter'
Rails.application.config.middleware.use Prometheus::Middleware::Collector
Rails.application.config.middleware.use Prometheus::Middleware::Exporter
