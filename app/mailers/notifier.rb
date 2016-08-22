class Notifier < ApplicationMailer
  default from: 'notifications@gov.au'

  def author_request(request)
    @request = request
    @url = editorial_section_request_url(@request.section, @request)
    # TODO: Once users have a name, include that here
    to = User.with_role(:owner, @request.section).pluck(:email)
    unless to.empty?
      mail(to: to,
           subject: "Collaboration request for #{@request.section.name} from #{@request.user.email}") do |format|
        format.text
        format.html
      end
    end
  end

  def user_invite(user, reset_token)
    @user = user
    @url = user_confirmation_url(confirmation_token: @user.confirmation_token, reset_password_token: reset_token)
    mail(to: user.email, subject: "Invitation to GOV.AU Beta") do |format|
      format.text
      format.html
    end
  end

  def beta_invite(invite)
    @url = invite_url(invite)
    mail(to: invite.email, subject: 'Invitation to GOV.AU Beta') do |format|
      format.text
      format.html
    end
  end

end
