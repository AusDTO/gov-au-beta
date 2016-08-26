require 'rails_helper'

RSpec.describe SendTwoFactorAuthenticationCodeJob, type: :job do
  let!(:complete_user) {
    Fabricate(:user, bypass_tfa: false, confirmed_at: Time.now.utc,
              phone_number: '0423456789', identity_verified_at: Time.now.utc)
  }

  let!(:valid_authenticate_request) {
    stub_request(:post, Rails.configuration.sms_authenticate_url).
        with(:body => {"client_id"=>"", "client_secret"=>"", "grant_type"=>"client_credentials", "scope"=>"SMS"},
             :headers => {'Content-Type'=>'application/x-www-form-urlencoded'}).
        to_return(:status => 200, :body => '{"access_token":"somereallyspecialtoken", "expires_in":"3599"}', :headers => {}
        )
  }

  describe 'with a random code' do
    subject { described_class.perform_now('112233', complete_user)}
    let!(:send_sms_request) {
      stub_request(:post, Rails.configuration.sms_send_message_url).
          with(:body => "{\"to\":\"#{complete_user.phone_number}\",\"body\":\"Your GOV.AU two-factor authentication code is 112233\"}",
               :headers => {'Authorization'=>'Bearer somereallyspecialtoken', 'Content-Type'=>'application/json'}).
          to_return(:status => 200, :body => "", :headers => {}
          )
    }

    it 'sends the api request' do
      subject
      expect(send_sms_request).to have_been_requested
    end
  end
end
