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
end
