class InvitesController < ApplicationController
  skip_before_action :authorize_invite_access

  before_action :check_invite_required, only: [:required, :show]

  load_and_authorize_resource :only => [:new, :create]

  layout :resolve_layout

  def new
    @invite = Invite.new
    @form = InviteForm.new(@invite)
  end

  def create
    @form = InviteForm.new(Invite.new)
    if @form.validate(invite_params)
      @form.sync
      @invite = @form.model
      InviteCreator.new(@invite.email).perform!

      flash[:alert] = "Invite has been sent to #{@invite.email}"
      redirect_to new_invite_url
    else
      render :new
    end
  end

  def show
    @invite = Invite.find_by!(:code => params[:id])

    if @invite.accepted?
      if current_invite == @invite
        redirect_to root_path
      end
      raise ActiveRecord::RecordNotFound
    end
  end

  def update
    @invite = Invite.find_by!(code: params[:id])
    token = InviteAccepter.new(@invite).perform!
    cookies[Invite::COOKIE_NAME] = {value: token, expires: 1.month.from_now}
    redirect_to root_url
  end

  private
  def invite_params
    params.require(:invite).permit(:email)
  end

  def check_invite_required
    redirect_to root_path unless Rails.configuration.require_invite
  end

  def resolve_layout
    if ['required', 'show'].include? action_name
      'invite'
    else
      'application'
    end
  end
end
