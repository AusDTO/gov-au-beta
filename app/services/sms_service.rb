# API adapter for Telstra specification
# https://dev.telstra.com/content/sms-getting-started
class SMSService
  include HTTParty

  @@token = @@token_expires_at = nil

  def initialize
    @@token_expires_at = @@token_expires_at || Time.now

    if @@token.nil? || @@token_expires_at <= Time.now
      set_token
    end
  end


  def send_two_factor_confirmation_code_for!(phone_number_field, code_field, user)
    # Should only ever receive a symbol defined in code, not by the user
    phone_number = user.send(phone_number_field)
    code = user.send(code_field)
    if phone_number != nil && code != nil
      send_two_factor_confirmation_code!(phone_number, code)
    else
      raise "Phone number or OTP not set"
    end
  end


  def send_two_factor_confirmation_code!(phone_number, code)
    send_sms(
      phone_number,
      "Your GOV.AU two-factor authentication code is #{code}"
    )
  end


  private
  def self.token
    @@token
  end


  def self.token_expiry
    @@token_expires_at
  end


  def set_token
    response = self.class.post(
      Rails.configuration.sms_authenticate_url,
      headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
      body: {
          client_id: Rails.application.secrets.sms_consumer_key,
          grant_type: 'client_credentials',
          client_secret: Rails.application.secrets.sms_consumer_secret,
          scope: 'SMS'
      }
    )

    if response.code == 200
      @@token = JSON.parse(response.body)['access_token']

      #Build some slack into token expiry so that we overlap nicely
      @@token_expires_at = (Time.now + JSON.parse(response.body)['expires_in'].to_i.seconds) - 1.minute
    else
      puts response
      raise "error getting token"
    end
  end


  def send_sms(phone_number, message)
    self.class.post(
      Rails.configuration.sms_send_message_url,
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{@@token}"
      },
      body: {
        to: phone_number,
        body: message
      }.to_json
    )
  end
end