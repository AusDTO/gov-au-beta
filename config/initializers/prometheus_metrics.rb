require 'prometheus/client/rack/collector'
require 'prometheus/client/rack/exporter'
Rails.application.config.middleware.use Prometheus::Client::Rack::Collector
Rails.application.config.middleware.use Prometheus::Client::Rack::Exporter