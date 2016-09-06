class SessionsController < Devise::SessionsController

  def create
    super
    log_event("user_login")
  end

  def destroy
    super
    log_event("user_logout")
  end

  # http://stackoverflow.com/a/33230548
  Warden::Manager.before_failure do |env, opts|
    email = env["action_dispatch.request.request_parameters"][:user] &&
        env["action_dispatch.request.request_parameters"][:user][:email]
    # unfortunately, the User object has been lost by the time
    # we get here; so we take a db hit because I care to see
    # if the email matched a user account in our system
    user_exists = User.where(email: email).exists?

    if opts[:message] == :unconfirmed
      # this is a special case for me because I'm using :confirmable
      # the login was correct, but the user hasn't confirmed their
      # email address yet
      LoggingHelper.log_event(LoggingHelper.current_request, LoggingHelper.current_user,
                              {event:"user_failed_login", user:email, cause: "unconfirmed account"})
    elsif opts[:action] == "unauthenticated"
      # "unauthenticated" indicates a login failure
      if !user_exists
        # bad email:
        # no user found by this email address
        LoggingHelper.log_event(LoggingHelper.current_request, LoggingHelper.current_user,
                                {event:"user_failed_login", user:email, cause: "no user found by this email address"})
      else
        # the user exists in the db, must have been a bad password
        LoggingHelper.log_event(LoggingHelper.current_request, LoggingHelper.current_user,
                                {event:"user_failed_login", user:email, cause: "bad password"})
      end
    end
  end

end