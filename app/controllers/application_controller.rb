require 'digest/sha1'

class ApplicationController < ActionController::Base
  include IncompleteTfaSetup
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :complete_two_factor_setup
  helper_method :decorated_current_user
  around_action :setup_logging

  def setup_logging
    begin
      LoggingHelper.begin_request(request, current_user)
      yield
    ensure
      # cleanup happens whether or not there is an error
      LoggingHelper.cleanup
    end
  end

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

  # Calls *stale?* but modifies any supplied *strong_etag* by prepending the value of 
  # ApplicationController#etag_seed.
  def bustable_stale?(object = nil, **kwd_args)
    etag_disabled? || stale?(object, strong_etag: bustable_etag(kwd_args[:strong_etag]), **kwd_args)
  end

  # Calls *fresh_when?* but modifies any supplied *strong_etag* by prepending the value of 
  # ApplicationController#etag_seed.
  def bustable_fresh_when(object = nil, **kwd_args)
    !etag_disabled? && fresh_when(object, strong_etag: bustable_etag(kwd_args[:strong_etag]), **kwd_args)
  end

  private

  if Rails.env.development?
    def etag_disabled?
      true
    end
  else
    def etag_disabled?
      user_signed_in? || flash.present?
    end
  end

  if Rails.env.development? || Rails.env.test?
    def etag_seed
      ""
    end
  else
    def etag_seed
      Rails.configuration.version_tag
    end
  end

  def bustable_etag(strong_etag)
    Digest::SHA1.hexdigest("#{etag_seed}#{strong_etag || ""}")
  end

  def append_info_to_payload(payload)
    super
    LoggingHelper.append_info_to_payload(request,current_user,payload)
  end
end
