class RegistrationsController < Devise::RegistrationsController
  before_action :confirm_two_factor!, only: [:edit]


  private

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password)
  end
end