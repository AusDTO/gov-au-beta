class SMSService
  include HTTParty

  @@token = @@token_expires_at = nil

  def initialize
    @@token_expires_at = @@token_expires_at || Time.now

    if @@token.nil? || @@token_expires_at <= Time.now
      set_token
    end
  end

  def send_unconfirmed_number_confirmation_code(user)
    send_user_otp(user, user.unconfirmed_phone_number)
  end

  def send_two_factor_confirmation_code(user)
    send_user_otp(user, user.phone_number)
  end

  def send_user_otp(user, phone_number)
    if phone_number != nil && user.direct_otp != nil
      send_sms(
        user.phone_number,
        "Your GOV.AU two-factor authentication code is #{user.direct_otp}"
      )
    else
      raise "Phone number or OTP not set"
    end
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
      @@token_expires_at = (Time.now + JSON.parse(response.body)['expires_in'].to_i.seconds)
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