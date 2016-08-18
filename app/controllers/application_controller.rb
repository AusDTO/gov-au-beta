require 'digest/sha1'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, :alert => exception.message }
      format.json { render status: :unauthorized, json: { message: exception.message } }
    end
  end

  def current_user
    super.try(:decorate)
  end

  protected

  # Calls *stale?* but modifies any supplied *strong_etag* by prepending the value of 
  # ApplicationController#etag_seed.
  def bustable_stale?(object = nil, **kwd_args)
    stale?(object, strong_etag: bustable_etag(kwd_args[:strong_etag]), **kwd_args)
  end

  # Calls *fresh_when?* but modifies any supplied *strong_etag* by prepending the value of 
  # ApplicationController#etag_seed.
  def bustable_fresh_when(object = nil, **kwd_args)
    fresh_when(object, strong_etag: bustable_etag(kwd_args[:strong_etag]), **kwd_args)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end

  private

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

  def after_sign_in_path_for(resource)
    if resource.has_role?(:admin)
      admin_root_path
    else
      editorial_root_path
    end
  end
end
