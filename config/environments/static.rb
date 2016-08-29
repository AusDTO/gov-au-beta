# config/environments/static.rb
require File.expand_path('../development', __FILE__)
# environment for serving static pages like error pages to upload to S3
Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.serve_static_assets = true
  config.assets.compress = true
  config.assets.compile = false
  config.assets.digest = true
  config.public_file_server.enabled = true
  config.assets.js_compressor = :uglifier
  config.assets.debug = false

  Rails.application.routes.default_url_options = {
      protocol: 'http',
      host: 'localhost:3001'
  }

  #Set use of two-factor auth
  config.use_2fa = false
end
