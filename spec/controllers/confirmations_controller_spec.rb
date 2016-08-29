require 'rails_helper'

RSpec.describe ConfirmationsController, type: :controller do

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe '#show' do
    let (:user) {Fabricate(:user, unconfirmed: true)}
    let (:reset_token) { 'reset_token' }

    context 'with reset token' do
      subject { get :show, params: {confirmation_token: user.confirmation_token, reset_password_token: reset_token} }

      it { is_expected.to redirect_to(edit_user_password_url(reset_password_token: :reset_token)) }
    end

    context 'without reset token' do
      subject { get :show, params: {confirmation_token: user.confirmation_token} }

      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end


end
