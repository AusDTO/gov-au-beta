# Preview all emails at http://localhost:3000/rails/mailers/notifier
class NotifierPreview < ActionMailer::Preview
  def author_request
    Notifier.author_request(Request.first)
  end

  def user_invite
    u = User.first
    u.confirmation_token = 'confirmation_token'
    Notifier.user_invite(u, 'reset_password_token')
  end
end
