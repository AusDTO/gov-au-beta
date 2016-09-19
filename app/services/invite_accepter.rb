class InviteAccepter

  def initialize(invite)
    @invite = invite
  end

  def perform!
    raise 'Already accepted' if @invite.accepted?
    generate_token.tap do |token|
      @invite.update!(
          accepted_at: Time.now,
          accepted_token: token
      )
    end
  end

  private
  def generate_token
    Digest::SHA1.hexdigest([@invite.email, SecureRandom.hex(32)].join)
  end
end
