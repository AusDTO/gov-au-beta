require 'rails_helper'

RSpec.describe SMSService, type: :service do
  let!(:user) { Fabricate(:user, phone_number: '0423456789', direct_otp: '123456') }
  let!(:send_sms_request) {
    stub_request(:post, "https://smsapi.com:80/send").
        with(:body => "{\"to\":\"#{user.phone_number}\",\"body\":\"Your GOV.AU two-factor authentication code is #{user.direct_otp}\"}",
             :headers => {'Authorization'=>'Bearer somereallyspecialtoken', 'Content-Type'=>'application/json'}).
        to_return(:status => 200, :body => "", :headers => {})
  }

  let!(:valid_authenticate_request) {
    stub_request(:post, Rails.configuration.sms_authenticate_url).
        with(:body => {"client_id"=>"", "client_secret"=>"", "grant_type"=>"client_credentials", "scope"=>"SMS"},
             :headers => {'Content-Type'=>'application/x-www-form-urlencoded'}).
        to_return(:status => 200, :body => '{"access_token":"somereallyspecialtoken", "expires_in":"3599"}', :headers => {})
  }

  subject { SMSService.new }

  context 'with correct credentials' do
    before {
      # Reset SMSService
      SMSService.class_variable_set :@@token_expires_at, nil
      SMSService.class_variable_set :@@token, nil
    }

    it {
      expect { subject }.to change { SMSService.token }.to('somereallyspecialtoken')
    }

    it {
      expect { subject }.to change { SMSService.token_expiry }
    }

    it 'made the request' do
      subject
      expect(valid_authenticate_request).to have_been_requested
    end
  end


  context 'with incorrect credentials' do
    let!(:invalid_authenticate_request) {
      stub_request(:post, 'https://badurl.com').
          with(:body => {"client_id"=>"", "client_secret"=>"", "grant_type"=>"client_credentials", "scope"=>"SMS"},
               :headers => {'Content-Type'=>'application/x-www-form-urlencoded'}).
          to_return(:status => 400, :body => '{"access_token":"somereallyspecialtoken", "expires_in":"3599"}', :headers => {})
    }

    before {
      Rails.configuration.sms_authenticate_url = 'https://badurl.com'
      SMSService.class_variable_set :@@token_expires_at, nil
      SMSService.class_variable_set :@@token, nil
    }

    it 'should raise an error' do
      expect { subject }.to raise_error('error getting token')
    end
  end


  context 'with a user with correct details' do
    context 'when sending an sms' do
      before {
        SMSService.new.send_two_factor_confirmation_code_for!(:phone_number, :direct_otp, user)
      }

      it { expect(send_sms_request).to have_been_requested }
    end
  end


  context 'with a user without correct details' do
    context 'when sending an sms' do
      before{
        user.phone_number = nil
        user.direct_otp = nil
        user.save
      }

      let(:bad_call) { SMSService.new.send_two_factor_confirmation_code_for!(:phone_number, :direct_otp, user) }

      it 'should raise an error' do
        expect{ bad_call }.to raise_error('Phone number or OTP not set')
      end
    end
  end
end