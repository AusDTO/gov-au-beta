module Users
  class TfaController < ::ApplicationController
    def new
    end

    def create
      current_user.unconfirmed_phone_number =  params[:phone_number]

      if current_user.validate
        current_user.create_direct_otp

        response = SMSService.new.send_sms(
          current_user.unconfirmed_phone_number,
          "Please complete your two-factor setup: #{current_user.direct_otp}"
        )

        if response.code == 202
          redirect_to users_two_factor_confirm_path and return
        end
      end
      render :new
    end

    def confirm
    end

    def update
      direct_otp_expiry = Rails.configuration.devise.direct_otp_valid_for
      grace_window = current_user.direct_otp_sent_at + direct_otp_expiry

      if grace_window > DateTime.now
        if current_user.authenticate_otp(params[:phone_number_otp])
          current_user.phone_number = current_user.unconfirmed_phone_number
          current_user.unconfirmed_phone_number = nil
          current_user.account_verified = true
          current_user.save

          redirect_to root_path
        else
          # TODO: limit opportunities to re-try
          render :confirm
        end
      else
        redirect_to users_two_factor_path
      end
    end
  end

  private

  def identity_check

  end
end
