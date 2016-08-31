class SessionsController < Devise::SessionsController
  after_filter :log_failed_login, :only => :new

  def create
    super
    LoggingHelper.log_event(request,current_user,{event:"success_login"})
  end

  private
  def log_failed_login
    LoggingHelper.log_event(request,current_user,{event:"failed_login",user:request.filtered_parameters["user"]}) if failed_login?
  end

  def failed_login?
    (options = env["warden.options"]) && options[:action] == "unauthenticated"
  end
end