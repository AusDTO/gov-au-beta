class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, :alert => exception.message }
      format.json { render status: :unauthorized, json: { message: exception.message } }
    end
  end

  def current_user
    super.try(:decorate)
  end

  private

  def after_sign_in_path_for(resource)
    if resource.has_role?(:admin)
      admin_root_path
    else
      editorial_root_path
    end
  end
end
