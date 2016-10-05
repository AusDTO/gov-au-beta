require 'digest/sha1'

class ApplicationController < ActionController::Base
  include IncompleteTfaSetup, InviteConcern
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :complete_two_factor_setup
  before_action :authorize_invite_access
  helper_method :decorated_current_user
  around_action :setup_logging

  # Sets additional data to generate etags
  # This ensures we bust etags over releases
  # See http://api.rubyonrails.org/classes/ActionController/ConditionalGet/ClassMethods.html#method-i-etag
  etag { etag_seed }

  def log_event(event, attrs = {})
    LoggingHelper.log_event(request, current_user, {event: event}.merge(attrs))
  end

  include AccessDeniedConcern

  def current_user
    super

    # TODO: this breaks lots of assumptions about current_user
    # being writeable, and requires more thought.
    # if user
    #   User.includes(:roles).find(user.id)
    # end
  end

  def decorated_current_user
    current_user.try(:decorate)
  end

  protected
  def confirm_two_factor!
    if current_user.account_verified && !current_user.bypass_tfa
      # Check identity last checked date
      if current_user.identity_expired?
        session[:target_redirect] = request.path
        redirect_to new_users_two_factor_verification_path
      end
    end
  end

  # Enforces the app-wide caching policy. Sets ETag & Cache-Control headers.
  #
  # Cache-Control is set to max-age of 5 minutes and public.  When pass a
  # block,the block will be yielded to in order to perform the render.  When a
  # block is not passed then Rails will perform the default rendering.  The
  # ETAG is busted when a new version of the application is deployed, but the
  # cache-control header will prevent conditional GETs to the server for five
  # minutes.
  #
  # Examples:
  #
  ## sets cache headers and renders with default renderer
  # with_caching([@resource1, @resource2])
  #
  ## sets cache headers and renders with explicit renderer
  # with_caching([@resource1, @resource2]) do
  #   render_this_way_instead
  # end
  #
  ## caching works on single or mutliple objects
  # with_caching(@resource)
  # with_caching([@resource1, @resource2])
  #
  def with_caching(object)
    if caching_enabled?
      if block_given?
        if stale?(strong_etag: object, last_modified: last_modified(object))
          expires_in 5.minutes, public: true
          yield
        end
      else
        fresh_when(strong_etag: object, last_modified: last_modified(object))
        expires_in 5.minutes, public: true
      end
    else
      puts "NO CACHE"
      if block_given?
        yield
      end
    end
  end

  private

  # Gets the max updated_at from an object or array of objects (or nil if no objects).
  def last_modified(object)
    [*object].compact.map do |obj|
      # expand ActiveRecord::Relations
      obj.try(:maximum, :updated_at) ||
      # fallback so single objects
      obj.try(:updated_at)
    end
    .compact
    .max
  end

  def setup_logging
    begin
      LoggingHelper.begin_request(request, current_user)
      yield
    ensure
      # cleanup happens whether or not there is an error
      LoggingHelper.cleanup
    end
  end

  # Decide whether a request is eligible for caching
  def caching_enabled?
    if ENV.has_key?('ENABLE_CACHING')
      return false unless ENV['ENABLE_CACHING'] == 'true' || ENV['ENABLE_CACHING'] == '1'
    else
      return false if Rails.env.development?
      return false if Rails.env.test?
    end
    cacheable_response?
  end

  # Decide if the response should be cached
  def cacheable_response?
    !(user_signed_in? || flash.present?)
  end

  def etag_seed
    Rails.configuration.version_tag
  end

  def append_info_to_payload(payload)
    super
    LoggingHelper.append_info_to_payload(request,current_user,payload)
  end
end
