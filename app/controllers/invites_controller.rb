class InvitesController < ApplicationController
  skip_before_action :beta_access

  def go
  end

  def show
    @invite = Invite.find_by!(code: params[:id])
    # TODO: If the invite has been accepted by me then redirect home otherwise 404
  end

  def update
    @invite = Invite.find(params[:id])
    token = InviteAccepter.new(@invite).perform
    cookies[:govau_beta_token] = { value: token, expires: 1.month.from_now }
    redirect_to root_url
  end
end
