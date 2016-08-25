module IncompleteTfaSetup
  extend ActiveSupport::Concern

  #TODO: eventually move this into a Warden after_authentication method
  def complete_two_factor_setup
    return unless Rails.configuration.use_2fa

    whitelist = [
        destroy_user_session_path
    ]

    if current_user && !current_user.account_verified && current_user.confirmed_at
      # Users need to be able to verify their tfa code
      unless request.path.start_with?(users_two_factor_setup_path) ||
          whitelist.include?(request.path)

        redirect_to new_users_two_factor_setup_path
      end
    end
  end
end