class UserChangeLogger
  REDACT_KEYS = %w(encrypted_password reset_password_token confirmation_token encrypted_otp_secret_key encrypted_otp_secret_key_iv encrypted_otp_secret_key_salt)

  def initialize(record)
    @record = record
    @changes = determine_changes(record)
  end

  def perform
    if @changes['encrypted_password']
      event = 'user_password_update'
    elsif @changes['reset_password_token']
      event = 'user_password_reset'
    elsif @changes['second_factor_attempts_count'] && @changes['second_factor_attempts_count'][1] > @changes['second_factor_attempts_count'][0]
      event = 'user_2fa_failed_attempt'
    elsif @changes['unconfirmed_email']
      event = 'user_email_update'
    elsif @changes
      event = 'user_update'
    end
    if event
      data = {event: event, record_id: @record.id, record_type: @record.class, record_name: @record.email, changes: @changes}
      LoggingHelper.log_event(LoggingHelper.current_request, LoggingHelper.current_user, data)
    end
  end

  private
  def determine_changes(record)
    record.changes.inject({}) do |h, (k, v)|
      if REDACT_KEYS.include?(k)
        h[k] =['REDACTED', 'REDACTED']
      else
        h[k] =v
      end
      h
    end
  end
end