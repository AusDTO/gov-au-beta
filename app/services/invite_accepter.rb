class InviteAccepter
  def initialize(invite)
    @invite = invite
  end

  def perform
    #validate_acceptable! TODO: transitor??
    generate_token.tap do |token|
      @invite.update!(
        accepted_at: Time.now,
        accepted_token: token
      )
    end
  end

  def generate_token
    Digest::SHA1.hexdigest([@invite.email, SecureRandom.hex(32)].join)
  end
end
