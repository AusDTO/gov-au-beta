class InviteCreator
  def initialize(email)
    @email = email
  end

  def perform
    Invite.create!(
      email: @email,
      code: generate_code
    )
  end

  private
    def generate_code
      candidate = SecureRandom.hex(4)
      if Invite.exists?(code: candidate)
        # Collision? Try again.
        generate_code
      else
        candidate
      end
    end
end
