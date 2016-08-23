require 'rails_helper'

RSpec.describe TwoFactorSetupController, type: :controller do
  render_views

  let!(:root_node) { Fabricate(:root_node) }
  let!(:otp_user) { Fabricate(:user, bypass_tfa: false) }
  let!(:totp_user) { Fabricate(:totp_user, bypass_tfa: false) }
  let!(:incomplete_user) {
    Fabricate(:user, bypass_tfa: false, confirmed_at: Time.now.utc,
              phone_number: nil, account_verified: false)
  }

  describe '#create' do
    

  end
end