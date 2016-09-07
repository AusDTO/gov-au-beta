module AccessDeniedConcern
  extend ActiveSupport::Concern

  included do
    rescue_from CanCan::AccessDenied do |exception|
      respond_to do |format|
        format.html do
          if user_signed_in?
            flash[:alert] = "You are not authorized to access this page."
            render 'errors/unauthorized', :status => :unauthorized
          else
            redirect_to new_user_session_path, :alert =>  "You must sign in to access the requested page."
          end
        end
        format.json { render status: :unauthorized, json: { message: exception.message } }
      end
    end
  end
end

