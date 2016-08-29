class ConfirmationsController < Devise::ConfirmationsController
  protected
  def after_confirmation_path_for(resource_name, resource)
    if params[:reset_password_token].present?
      edit_password_path(resource, reset_password_token: params[:reset_password_token])
    else
      super
    end
  end
end