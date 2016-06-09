# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_filters.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action ->() { authorize! :manage, :all }

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
  end
end
