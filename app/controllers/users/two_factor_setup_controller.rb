module Users
  class TwoFactorSetupController < TwoFactorVerificationController
    before_action :redirect_verified_users


    def index
    end


    def choice
      session[:setup_2fa] = []
      if params[:validation].nil?
        flash[:alert] = 'You must select at least one 2 factor verification method'
        redirect_to users_two_factor_setup_path and return
      end

      %w(sms authenticator).each do |type_2fa|
        session[:setup_2fa] += [type_2fa] if params[:validation].keys.include? type_2fa
      end

      continue_setup
    end


    def continue_setup
      unless session[:setup_2fa].blank?
        # Redirect to setup of session[:setup_2fa].first
        redirect_to send("new_users_two_factor_setup_#{session[:setup_2fa].shift}_path") and return
      end

      if current_user.phone_number.present? || current_user.totp_enabled?
        current_user.account_verified = true
        current_user.save
      end

      if current_user.account_verified
        flash[:notice] = 'Thanks. Your account has been verified. You are now signed in.'
        redirect_to root_path and return
      end

      redirect_to users_two_factor_setup_path
    end


    private

    # Only for accounts setting up
    def redirect_verified_users
      if current_user.account_verified
        redirect_to root_path and return
      end
    end
  end
end
