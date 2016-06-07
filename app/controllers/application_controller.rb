class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :init_toolbar_info

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, :alert => exception.message }
      format.json { render status: :unauthorized, json: { message: exception.message } }
    end
  end

  private

  def init_toolbar_info
    @toolbar_info = { visible: false }
  end

  def show_toolbar
    @toolbar_info[:visible] = true
  end
end
