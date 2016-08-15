module Users
  class TwoFactorController < ApplicationController

    def verify_identity

    end

    private
    def verify_identity
      # Check identity last checked date
      if current_user.identity_verified_at == nil
        identity_expires_at = 5.minutes.ago
      else
        identity_expires_at = current_user.identity_verified_at + \
                        Rails.configuration.devise.direct_otp_valid_for
      end

      if identity_expires_at < DateTime.now
        # Redirect to identity check process
        # Maintain request.path to redirect back to after completion
        redirect_to
      end
    end
  end
end