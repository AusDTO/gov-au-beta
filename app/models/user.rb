class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :two_factor_authenticatable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :confirmable

  has_many :requests

  has_one_time_password(encrypted: true)

  validates :email, email_domain_whitelist: true
  validates :phone_number, aus_phone_number: true
  validates :unconfirmed_phone_number, aus_phone_number: true

  def password_required?
    !persisted? || password.present? || password_confirmation.present?
  end

  def member_of_sections
    # Admins are implicit members of all sections
    if has_role? :admin
      Section.where.not(name: 'news')
    else
      roles.map { |role| role.resource }.reject(&:nil?).uniq
    end
  end

  def is_member?(section)
    member_of_sections.include? section
  end

  def pending_request_for(section)
    requests.find_by(section: section, state: 'requested')
  end

  def pending_request_for?(section)
    pending_request_for(section).present?
  end

  # FIXME: Rollify uses polymophism which doesn't work properly
  # with STI on Section. Suggest using a collaborator model on sections instead
  def collaborator_on?(section)
    roles.exists?(resource_id: section)
  end

  def send_two_factor_authentication_code(code)
    # response = SMSService.new.send_sms(
    #     self.phone_number,
    #     "Your two-factor authentication code to sign in to GOV.AU is #{code}"
    # )
    response = SMSService.new.send_two_factor_confirmation_code!(self)

    # TODO: handle SMS delivery-failure, and check the response is 202
    unless response.code == 202
      puts response
      raise "there was an error delivering the SMS"
    end
  end

  def need_two_factor_authentication?(request)
    #request.ip != '127.0.0.1' && !self.bypass_tfa
    !self.bypass_tfa && self.account_verified
  end

  def create_direct_otp_for(field)
    otp_service = OtpService.new(self)
    otp_service.create_otp(field)
  end

  def authenticate_direct_otp_for(field, code)
    otp_service = OtpService.new(self)
    otp_service.authenticate_otp(field, code)
  end

  def identity_expired?
    direct_otp_valid_for = Rails.configuration.devise.direct_otp_valid_for
    return identity_verified_at == nil || identity_verified_at + direct_otp_valid_for < Time.now.utc
  end
end
