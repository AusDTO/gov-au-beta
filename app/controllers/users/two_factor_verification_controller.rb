module Users
  class TwoFactorVerificationController < ApplicationController
    before_action :check_direct_otp_expiry, only: [:show, :create]


    def new
    end


    def create
      unless current_user.totp_enabled?
        current_user.create_direct_otp

        Thread.new do
          SMSService.new.send_two_factor_confirmation_code!(current_user)
        end
      end
      redirect_to confirm_users_two_factor_verification_path
    end


    def confirm
    end


    def update
      if current_user.authenticate_otp(params[:code])
        current_user.identity_verified_at = DateTime.now
        current_user.save!

        if (target_redirect = session[:target_redirect]) != nil
          session.delete(:target_redirect)
          redirect_to target_redirect and return
        else
          redirect_to :root and return
        end
      else
        render :show
      end
    end


    # https://github.com/Houdini/two_factor_authentication/blob/9d7d3472f4d272f70c2357ca4bced6f32ec2fbc9/app/controllers/devise/two_factor_authentication_controller.rb#L18
    def resend_code
      current_user.send_new_otp
      redirect_to users_two_factor_verification_path
    end


    private

    def check_direct_otp_expiry
      o = OtpService.new(current_user)
      o.clear_direct_otp(:direct_otp) if o.otp_expired?(:direct_otp)
    end
  end
end