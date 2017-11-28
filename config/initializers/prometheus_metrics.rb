require 'prometheus/middleware/collector'
require 'prometheus/middleware/exporter'
Rails.application.config.middleware.use Prometheus::Middleware::Collector
Rails.application.config.middleware.use Prometheus::Middleware::Exporter
