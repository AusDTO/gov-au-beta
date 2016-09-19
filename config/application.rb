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

    # Allow additional data through the sanitizer
    config.after_initialize do
      ActionView::Base.sanitized_allowed_tags.merge(%w{table th tr td thead tbody})
      ActionView::Base.sanitized_allowed_attributes.merge(%w{id})
      Loofah::HTML5::WhiteList::ALLOWED_PROTOCOLS.add('tel')
    end

    config.generators do |g|
      g.stylesheets false
      g.javascripts false
      g.helper false
      g.view_specs false
      g.decorator false
    end

    config.time_zone = "Sydney"

    config.exceptions_app = self.routes

    config.require_invite = ENV["REQUIRE_INVITE"].present?

    #logging

    config.lograge.enabled = true
    config.lograge.custom_options = lambda do |event|
      f = ActionDispatch::Http::ParameterFilter.new(Rails.application.config.filter_parameters)
      {
          # log all post params https://github.com/roidrage/lograge#what-it-doesnt-do
          # but filter via http://guides.rubyonrails.org/action_controller_overview.html#log-filtering
          params: f.filter(event.payload[:params]),
          user_id: event.payload[:user_id],
          user_email: event.payload[:user_email],
          headers: event.payload[:headers],
          ip: event.payload[:ip],
          event: 'http_request'
      }
    end
    # Catch 404s but only after gems have had a change to modify routes
    # https://github.com/vidibus/vidibus-routing_error#alternative-two
    config.after_initialize do |app|
      app.routes.append{match '*path', :to => 'errors#not_found', :via => :all}
    end


  end
end
