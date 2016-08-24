class OtpService
  # This service largely duplicates functions of the two_factor_authentication gem
  # However, as it makes assumptions as to the field to validate for direct otps,
  # this is required to extend that functionality to other fields.

  cattr_accessor :direct_otp_length
  cattr_accessor :direct_otp_valid_for

  @@direct_otp_valid_for = Rails.configuration.devise.direct_otp_valid_for
  @@direct_otp_length = Rails.configuration.devise.direct_otp_length


  def initialize(user)
    @user = user
  end


  def authenticate_otp(code_field, code)
    # Should only ever receive a symbol defined in code, not by the user
    direct_otp = @user.send(code_field)
    return false if direct_otp.nil? || direct_otp != code || otp_expired?(code_field.to_sym)
    clear_direct_otp(code_field)
    true
  end


  # https://github.com/Houdini/two_factor_authentication/blob/9d7d3472f4d272f70c2357ca4bced6f32ec2fbc9/lib/two_factor_authentication/models/two_factor_authenticatable.rb
  def otp_expired?(direct_otp)
    # Should only ever receive a symbol defined in code, not by the user
    sent_at =  @user.send("#{direct_otp}_sent_at")
    sent_at == nil || (Time.now.utc > sent_at + self.class.direct_otp_valid_for)
  end


  def clear_direct_otp(field)
    @user.update_attributes(
      field.to_sym => nil,
      "#{field}_sent_at".to_sym => nil
    )
  end


  def create_direct_otp!(field, options = {})
    digits = options[:length] || self.class.direct_otp_length || 6
    @user.update_attributes(
      field.to_sym => random_base10(digits),
      "#{field}_sent_at".to_sym => Time.now.utc
    )
  end

  private

  def random_base10(digits)
    SecureRandom.random_number(10**digits).to_s.rjust(digits, '0')
  end
end