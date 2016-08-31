require 'rails_helper'

RSpec.describe SendTwoFactorAuthenticationCodeForJob, type: :job do
  Warden.test_mode!

  let!(:complete_user) {
    Fabricate(:user, bypass_tfa: false, confirmed_at: Time.now.utc,
              phone_number: '0423456789', identity_verified_at: Time.now.utc,
              direct_otp: '123456', unconfirmed_phone_number: '0411111111',
              unconfirmed_phone_number_otp: '654321')
  }

  let!(:valid_authenticate_request) {
    stub_request(:post, Rails.configuration.sms_authenticate_url).
      with(:body => {"client_id"=>"", "client_secret"=>"", "grant_type"=>"client_credentials", "scope"=>"SMS"},
          :headers => {'Content-Type'=>'application/x-www-form-urlencoded'}).
      to_return(:status => 200, :body => '{"access_token":"somereallyspecialtoken", "expires_in":"3599"}', :headers => {}
    )
  }

  before(:each) do
    SMSService.class_variable_set :@@token, nil
  end

  describe 'for a confirmed user phone number' do
    subject { described_class.perform_now(:phone_number, :direct_otp, complete_user)}
    let!(:send_sms_request) {
      stub_request(:post, Rails.configuration.sms_send_message_url).
          with(:body => "{\"to\":\"#{complete_user.phone_number}\",\"body\":\"Your GOV.AU two-factor authentication code is #{complete_user.direct_otp}\"}",
               :headers => {'Authorization'=>'Bearer somereallyspecialtoken', 'Content-Type'=>'application/json'}).
          to_return(:status => 200, :body => "", :headers => {}
          )
    }

    it 'should authenticate the sms service and send the sms' do
      subject
      expect(valid_authenticate_request).to have_been_requested
      expect(send_sms_request).to have_been_requested
    end
  end


  describe 'for an unconfirmed user phone number' do
    subject {
      described_class.perform_now(
        :unconfirmed_phone_number,
        :unconfirmed_phone_number_otp,
        complete_user
      )
    }
    let!(:send_sms_request) {
      stub_request(:post, Rails.configuration.sms_send_message_url).
          with(:body => "{\"to\":\"#{complete_user.unconfirmed_phone_number}\",\"body\":\"Your GOV.AU two-factor authentication code is #{complete_user.unconfirmed_phone_number_otp}\"}",
               :headers => {'Authorization'=>'Bearer somereallyspecialtoken', 'Content-Type'=>'application/json'}).
          to_return(:status => 200, :body => "", :headers => {}
          )
    }

    it 'should authenticate the sms service and send the sms' do
      subject
      expect(valid_authenticate_request).to have_been_requested
      expect(send_sms_request).to have_been_requested
    end
  end
end
