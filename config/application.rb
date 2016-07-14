require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GovAuBeta
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Allow tables and telephone contact protocol links through the sanitizer
    config.after_initialize do
      ActionView::Base.sanitized_allowed_tags.merge(%w{table th tr td thead tbody})
      Loofah::HTML5::WhiteList::ALLOWED_PROTOCOLS.add('tel')
    end

    config.generators do |g|
      g.stylesheets false
      g.javascripts false
      g.helper false
      g.view_specs false
      g.decorator false
    end
  end
end
