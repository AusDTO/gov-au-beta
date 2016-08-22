module InviteConcern
  extend ActiveSupport::Concern

  def authorize_invite_access
    #Allow access if toggled off
    return unless Rails.configuration.require_invite

    #Allow access if user already logged in with devise
    return if current_user

    #Allow access if trying to sign_in
    return if [new_user_session_path].include? request.path

    #Allow access if has accepted invite
    redirect_to required_invites_path unless current_invite.present?
  end

  def current_invite
    token = cookies[Invite::COOKIE_NAME]
    return nil if token.blank?
    Invite.find_by(accepted_token: token)
  end
end