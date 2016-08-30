module Users
  module TwoFactorSetup
    class SmsSetupController < TwoFactorVerificationController
      before_action :authenticate_user!
      before_action :confirm_two_factor!
      before_action :verify_direct_otp_sent, only: [:confirm, :update]

      # Display view to send one-time-password or input authenticator code
      def new
      end


      # Send SMS and redirect to confirm if valid number
      def create
        unless params[:phone_number].nil?
          current_user.unconfirmed_phone_number =  params[:phone_number]

          if current_user.save
            current_user.send_new_direct_otp_for(:unconfirmed_phone_number)
            redirect_to confirm_users_two_factor_setup_sms_path and return
          end
        end

        flash[:alert] = "Your phone number didn't look right. Please try again."
        render :new
      end


      # Give form to input one-time-password
      def confirm
      end


      # Validate one-time-password and redirect if successful
      def update
        if current_user.authenticate_direct_otp_for(:unconfirmed_phone_number_otp, params[:code])
          current_user.phone_number = current_user.unconfirmed_phone_number
          current_user.unconfirmed_phone_number = nil
          #current_user.account_verified = true
          current_user.save!

          flash[:notice] = 'You have successfully verified and saved your phone number'

          redirect_to continue_setup_users_two_factor_setup_path #root_path
        else
          # TODO: limit opportunities to re-try
          flash[:alert] = "Sorry, your code didn't work. Please try again."
          render :confirm
        end
      end


      def resend_code
        current_user.send_new_direct_otp_for(:unconfirmed_phone_number)
        redirect_to confirm_users_two_factor_setup_sms_path
      end


      private
      # Don't let users skip ahead of being sent an actual code
      def verify_direct_otp_sent
        if current_user.unconfirmed_phone_number_otp == nil
          redirect_to new_users_two_factor_setup_sms_path
        end
      end
    end
  end
end