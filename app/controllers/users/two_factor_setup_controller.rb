module Users
  class TwoFactorSetupController < TwoFactorConfirmationController
    before_action :authenticate_user!
    before_action :confirm_two_factor!


    def new
    end


    def create
      current_user.unconfirmed_phone_number =  params[:phone_number]

      if current_user.save
        current_user.create_direct_otp
        response = SMSService.new.send_unconfirmed_number_confirmation current_user

        # TODO: handle service failure
        if response.code == 202
          redirect_to users_two_factor_confirm_path and return
        end
      end

      render :new
    end


    def confirm
    end


    def update
      if current_user.authenticate_otp(params[:code])
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
  end
end
