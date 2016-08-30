module Users
  module TwoFactorSetup
    class AuthenticatorSetupController < TwoFactorVerificationController
      before_action :authenticate_user!
      before_action :confirm_two_factor!
      before_action :generate_qrcode, only: [:create]

      def new
        # Generate TOTP
        unless session[:setup_totp].present?
          session[:setup_totp] = current_user.generate_totp_secret
        end

        generate_qrcode
      end


      def create
        if session[:setup_totp].present?
          if authenticate_code(session[:setup_totp], params[:code])
            current_user.otp_secret_key = session[:setup_totp]
            current_user.save!
            session.delete :setup_totp

            flash[:notice] = 'Thanks. You have set and verified your authenticator code.'

            if current_user.account_verified
              redirect_to root_path and return
            end

            redirect_to continue_setup_users_two_factor_setup_path and return
          end

          @form_error = "Your code didn't work. Please try again."
          render :new and return
        end

        redirect_to new_users_two_factor_setup_authenticator_path
      end


      def resend_code
        session[:setup_totp] = current_user.generate_totp_secret
        redirect_to new_users_two_factor_setup_authenticator_path
      end


      private
      def authenticate_code(key, code)
        unless code.nil? || key.nil?
          return ROTP::TOTP.new(key).now == code
        end

        return false
      end


      def generate_qrcode
        @totp_secret = session[:setup_totp]

        if @totp_secret
          @qrcode_uri = "otpauth://totp/#{current_user.email}?secret=#{@totp_secret}&issuer=gov.au"
          @qrcode = RQRCode::QRCode.new(@qrcode_uri).as_png(
              fill: 'white',
              color: 'black',
              size: 250,
              file: nil,
              border_modules: 2,
              module_px_size: 6,
          )
        end
      end
    end
  end
end