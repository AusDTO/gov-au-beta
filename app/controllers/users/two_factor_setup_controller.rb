module Users
  class TwoFactorSetupController < TwoFactorVerificationController
    before_action :authenticate_user!
    before_action :confirm_two_factor!
    before_action :verify_direct_otp_sent, only: [:confirm, :update]

    def new
    end


    def create
      current_user.unconfirmed_phone_number =  params[:phone_number]

      if current_user.save
        current_user.create_direct_otp_for(:unconfirmed_phone_number_otp)

        # For now, dispatch SMS in new thread and redirect user immediately
        # User is able to request another SMS code if this is not delivered
        Thread.new do
          SMSService.new.send_unconfirmed_number_confirmation_code! current_user
        end
        redirect_to confirm_users_two_factor_setup_path and return
      end

      render :new
    end


    def confirm
    end


    def update
      if current_user.authenticate_direct_otp_for(:unconfirmed_phone_number_otp, params[:code])
        current_user.phone_number = current_user.unconfirmed_phone_number
        current_user.unconfirmed_phone_number = nil
        current_user.account_verified = true
        current_user.save!

        redirect_to root_path
      else
        # TODO: limit opportunities to re-try
        render :confirm
      end
    end

    private
    def verify_direct_otp_sent
      if current_user.unconfirmed_phone_number_otp == nil
        redirect_to new_users_two_factor_setup_path
      end
    end
  end
end
