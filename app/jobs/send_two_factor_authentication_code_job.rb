class SendTwoFactorAuthenticationCodeJob < ApplicationJob
  queue_as :default

  def perform(code, user)
    SMSService.new.send_two_factor_confirmation_code!(
      user.phone_number,
      code
    )
  end
end
