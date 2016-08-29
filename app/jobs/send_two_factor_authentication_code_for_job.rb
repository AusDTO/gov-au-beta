class SendTwoFactorAuthenticationCodeForJob < ApplicationJob
  queue_as :default

  def perform(phone_number_field, code_field, user)
    SMSService.new.send_two_factor_confirmation_code_for! phone_number_field, code_field, user
  end
end
