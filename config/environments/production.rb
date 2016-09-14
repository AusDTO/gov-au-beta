Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between features.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # `config.assets.precompile` and `config.assets.version` have moved to config/initializers/assets.rb

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Action Cable endpoint configuration
  # config.action_cable.url = 'wss://example.com/cable'
  # config.action_cable.allowed_request_origins = [ 'http://example.com', /http:\/\/example.*/ ]

  # Don't mount Action Cable in the main server process.
  # config.action_cable.mount_path = nil

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :debug

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Use a real queuing backend for Active Job (and separate queues per environment)
  config.active_job.queue_adapter     = :async
  config.active_job.queue_name_prefix = "gov-au-beta_#{Rails.env}"

  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  config.action_mailer.delivery_method = :ses

  config.action_mailer.default_url_options = {
    protocol: 'https',
    host: ENV["APP_DOMAIN"]
  }
  Rails.application.routes.default_url_options = {
      protocol: 'https',
      host: ENV["APP_DOMAIN"]
  }

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Use a different logger for distributed setups.
  # require 'syslog/logger'
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  if ENV["HTTP_USERNAME"] && ENV["HTTP_PASSWORD"]
    config.middleware.use '::Rack::Auth::Basic' do |u, p|
      [u, p] == [ENV["HTTP_USERNAME"], ENV["HTTP_PASSWORD"]]
    end
  end
  
  config.version_tag = ENV['CIRCLE_TAG']
  config.version_sha = ENV['CIRCLE_SHA1']

  # Set SMS provider
  config.sms_authenticate_url = ENV['SMS_AUTHENTICATE_URL']
  config.sms_send_message_url = ENV['SMS_SEND_MESSAGE_URL']

  #Set use of two-factor auth
  config.use_2fa = !ENV['DISABLE_2FA'].present?

  # use s3 for file uploads
  config.paperclip_defaults = { storage: :s3,
                                s3_region: ENV['AWS_REGION'],
                                s3_credentials: {:bucket => ENV['AWS_ASSET_S3_BUCKET'],
                                                 :access_key_id => ENV['AWS_S3_ACCESS_KEY_ID'],
                                                 :secret_access_key => ENV['AWS_S3_SECRET_ACCESS_KEY']},
                                path: "/assets/:fingerprint-:style.:extension",
                                # path determines location on S3
                                # https://github.com/thoughtbot/paperclip/tree/master/lib/paperclip/interpolations.rb#L159
                                s3_host_alias: ENV['ASSET_DOMAIN'] || "s3-#{ENV['AWS_REGION']}.amazonaws.com/#{ENV['AWS_ASSET_S3_BUCKET']}",
                                # The fully-qualified domain name (FQDN) that is the alias to the S3 domain of your bucket.
                                url: ":s3_alias_url"
                            }
end
