# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_filters.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
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


    #TODO: eventually move this into a Warden after_authentication method
    def complete_two_factor_setup
      whitelist = [
          destroy_user_session_path
      ]

      if current_user && !current_user.account_verified && current_user.confirmed_at
        # Users need to be able to verify their tfa code
        unless request.path.start_with?(users_two_factor_setup_path) ||
            whitelist.include?(request.path)

          redirect_to new_users_two_factor_setup_path
        end
      end
    end
  end
end
