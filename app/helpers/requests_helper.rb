module RequestsHelper
  def show_request_controls?
    return false unless user_signed_in?
    @section.present? && !current_user.collaborator_on?(@section)
  end
end
