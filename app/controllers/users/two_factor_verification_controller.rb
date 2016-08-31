module Users
  class TwoFactorVerificationController < ApplicationController
    before_action :authenticate_user!
    before_action :check_direct_otp_expiry, only: [:show, :create, :confirm]

    def new
    end


    def create
      unless current_user.totp_enabled?
        current_user.send_new_direct_otp_for(:phone_number, :direct_otp)
      end
      redirect_to confirm_users_two_factor_verification_path
    end


    def confirm
    end


    def update
      if authenticate_code
        current_user.confirm_identity!
        flash[:notice] = 'Thanks. You account has been verified.'
        if session[:target_redirect].present?
          redirect_to session.delete(:target_redirect) and return
        else
          redirect_to :root and return
        end
      else
        flash[:alert] = "Sorry, your code didn't work. Please try again."
        redirect_to confirm_users_two_factor_verification_path
      end
    end


    # https://github.com/Houdini/two_factor_authentication/blob/9d7d3472f4d272f70c2357ca4bced6f32ec2fbc9/app/controllers/devise/two_factor_authentication_controller.rb#L18
    def resend_code
      current_user.send_new_direct_otp_for(:phone_number, :direct_otp)
      redirect_to confirm_users_two_factor_verification_path
    end


    private
    def check_direct_otp_expiry
      o = OtpService.new(current_user)
      o.clear_direct_otp(:direct_otp) if o.otp_expired?(:direct_otp)
    end


    def authenticate_code
      return true if current_user.direct_otp && current_user.authenticate_otp(params[:code])
      return true if current_user.totp_enabled? && current_user.authenticate_totp(params[:code])
      false
    end
  end
end