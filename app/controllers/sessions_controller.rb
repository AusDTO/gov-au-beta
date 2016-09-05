class SessionsController < Devise::SessionsController
  after_actiongi :log_failed_login, :only => :new

  def create
    super
    LoggingHelper.log_event(request,current_user,{event:"user_login"})
  end

  def destroy
    super
    LoggingHelper.log_event(request,current_user,{event:"user_logout"})
  end

  private
  def log_failed_login
    LoggingHelper.log_event(request,current_user,{event:"user_failed_login",user:request.filtered_parameters["user"]}) if failed_login?
  end

  def failed_login?
    (options = ENV["warden.options"]) && options[:action] == "unauthenticated"
  end
end