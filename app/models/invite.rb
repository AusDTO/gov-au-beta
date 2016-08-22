class Invite < ApplicationRecord

  COOKIE_NAME = 'invite_accepted_token'

  validates :email, :presence => true, :email => true

  def accepted?
    accepted_token.present?
  end

  def to_param
    code
  end
end
