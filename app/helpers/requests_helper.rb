module RequestsHelper

  def open_request(user, section)

    Request.find_by(user: user, section: section, state: 'requested')

  end

end