# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_filters.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    include ::IncompleteTfaSetup
    include ::AccessDeniedConcern

    before_action ->() { authorize! :manage, :all }
    before_action :complete_two_factor_setup
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

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end

    def append_info_to_payload(payload)
      super
      LoggingHelper.append_info_to_payload(request,current_user,payload)
    end
  end
end
