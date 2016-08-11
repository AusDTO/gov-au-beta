class SMSService
  include HTTParty

  @@token = @@token_expires_at = nil

  def initialize
    @@token_expires_at = @@token_expires_at || Time.now

    if @@token.nil? || @@token_expires_at <= Time.now
      set_token
    end
  end

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

  def send_sms(user, message)
    if user.phone_number.present?
      self.class.post(
        Rails.configuration.sms_send_message_url,
        headers: {
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{@@token}"
        },
        body: {
          to: user.phone_number,
          body: message
        }
      )
    end
  end
end