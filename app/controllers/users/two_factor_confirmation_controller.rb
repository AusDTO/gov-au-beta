module Users
  class TwoFactorConfirmationController < ApplicationController
    def show
      unless current_user.totp_enabled?
        current_user.create_direct_otp
        @target_redirect = params[:target]
        r = SMSService.new.send_two_factor_confirmation_code(current_user)

        # TODO: make this async and handle service failure
        unless r.code == 202
          raise 'There was an error sending the SMS'
        end
      end
    end

    def create
      if current_user.authenticate_otp(params[:code])
        current_user.identity_verified_at = DateTime.now
        current_user.save!

        # TODO: sanitize this is an appropriate URL
        if (target = params[:target_redirect])
          redirect_to target
        end
      else
        render :show
      end
    end

    private
    def confirm_two_factor!
      if current_user.account_verified
        # Check identity last checked date
        if current_user.identity_verified_at == nil
          identity_expires_at = 5.minutes.ago
        else
          identity_expires_at = current_user.identity_verified_at + \
                          Rails.configuration.devise.direct_otp_valid_for
        end

        if identity_expires_at < DateTime.now
          @target_redirect = request.path
          render :show
        end
      end
    end
  end
end