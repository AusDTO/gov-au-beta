require 'rails_helper'
require 'support/shared_context_two_factor_login.rb'

RSpec.describe 'two factor setup', type: :feature do
  Warden.test_mode!

  let!(:root_node) { Fabricate(:root_node) }
  let!(:incomplete_user) {
    Fabricate(:user, bypass_tfa: false, confirmed_at: Time.now.utc,
              phone_number: nil, account_verified: false)
  }
  let!(:complete_user) {
    Fabricate(:user, bypass_tfa: false, confirmed_at: Time.now.utc,
              phone_number: '0423456789', identity_verified_at: Time.now.utc)
  }

  let!(:sms_authenticate_request) {
    stub_request(:post, Rails.configuration.sms_authenticate_url).
        with(:body => {"client_id"=>"", "client_secret"=>"", "grant_type"=>"client_credentials", "scope"=>"SMS"},
             :headers => {'Content-Type'=>'application/x-www-form-urlencoded'}).
        to_return(:status => 200, :body => '{"access_token":"somereallyspecialtoken", "expires_in":"3599"}', :headers => {})
  }

  let!(:sms_sms_request) {
    stub_request(:post, Rails.configuration.sms_send_message_url).
        with(:headers => {'Authorization'=>'Bearer somereallyspecialtoken', 'Content-Type'=>'application/json'}).
        to_return(:status => 200, :body => "", :headers => {})
  }


  describe 'incomplete admin 2fa setup' do
    let!(:admin) { Fabricate(:user, is_admin: true, bypass_tfa: false,
                              account_verified: false, phone_number: nil)
    }

    context 'when signing in' do
      before {
        login_as(admin)
        visit admin_root_path
      }

      it 'should force 2fa setup' do
        expect(page).to have_content('To sign up, you will need to verify your account')
      end
    end
  end


  describe 'complete 2fa' do
    before {
      login_as(incomplete_user)
      visit root_url
    }

    it 'redirects to 2fa setup after email confirmation' do
      expect(page).to have_content('To sign up, you will need to verify your account')
    end

    context 'when setting a phone number' do
      before{
        fill_in('Phone number', with: '0423456789')
        click_button('Send code')
      }


      it 'redirects to 2fa confirmation' do
        expect(page).to have_content('A text message with a verification code was just sent to')
      end


      it 'renders only two numbers of the phone number' do
        expect(page).to have_content('**** *** *89')
      end


      it 'has the option to resend a code' do
        expect(page).to have_link('Resend verification code')
      end


      it 'has the option to use a different number' do
        expect(page).to have_link('Use a different number')
      end


      context 'when setting the right code' do
        before {
          fill_in(
            'Enter 6 digit code',
            with: User.find(incomplete_user.id).unconfirmed_phone_number_otp
          )
          click_button('Verify')
        }

        it 'redirects to root' do
          expect(current_path).to eq(root_path)
          expect(page).to have_content('You have successfully verified and saved your phone number')
        end
      end

      context 'when setting the wrong code' do
        before {
          fill_in(
            'Enter 6 digit code',
            with: 'notacode'
          )
          click_button('Verify')
        }

        it 'displays an error' do
          expect(page).to have_content("Sorry, your code didn't work. Please try again.")
        end

        it 'lets user input another code' do
          expect(page).to have_field('Enter 6 digit code')
        end
      end
    end
  end

  describe 'change 2fa details' do
    include_context 'shared_two_factor_login'

    before {
      login_as(complete_user)
      complete_2fa_login(complete_user)
      visit new_users_two_factor_setup_path
    }

    it 'displays change phone number form' do
      expect(page).to have_content('Change your phone number')
      expect(page).to have_field('Phone number')
    end
  end
end