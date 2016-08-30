# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_filters.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    include ::IncompleteTfaSetup

    before_action ->() { authorize! :manage, :all }
    before_action :complete_two_factor_setup

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end

    rescue_from CanCan::AccessDenied do |exception|
      respond_to do |format|
        format.html { redirect_to new_user_session_path, :alert => exception.message }
        format.json { render status: :unauthorized, json: { message: exception.message } }
      end
    end
    # logging payload additions
    def append_info_to_payload(payload)
      super
      # http headers Host and X-Forwarded-For
      payload[:host] = request.host
      payload[:fwd] = request.remote_ip
      payload[:user_agent] = request.user_agent
      # Cloudfoundry gives each request an ID in HTTP header X-Cf-Requestid so log it
      payload[:cf_request_id] = request.try("X-Cf-Requestid")
      # Add user context if available https://github.com/roidrage/lograge/issues/23
      payload[:user_id] = current_user.id unless current_user.nil?
      payload[:user_email] = current_user.email unless current_user.nil?

    end
  end
end
