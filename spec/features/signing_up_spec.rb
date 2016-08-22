require 'rails_helper'

RSpec.describe 'signing up', type: :feature do

  Warden.test_mode!

  let!(:root_node) { Fabricate(:root_node) }

  let(:sign_up_and_verify) {
    visit new_user_registration_path
    fill_in('Email', with: 'test@example.gov.au')
    fill_in('First name', with: 'first')
    fill_in('Last name', with: 'last')
    # Can't use fill_in for Password because it's an ambiguous match
    find('#user_password').set('password')
    fill_in('Password confirmation', with: 'password')
    click_button('Sign up')
    email_body = Nokogiri::HTML.parse(ActionMailer::Base.deliveries.last.body.raw_source)
    signup_link_url = email_body.css("a")[0][:href]
    visit signup_link_url
  }


  describe 'account setup' do
    context 'user registration' do
      before {
        sign_up_and_verify
      }

      it 'sets the name' do
        expect(page).to have_content('Your email address has been successfully confirmed')
      end
    end
  end


  describe 'complete setup' do
    before {
      sign_up_and_verify
      login_as(User.find_by(email: 'test@example.gov.au'))
      visit root_url
    }

    context 'when logging in after email confirmation' do
      it 'shows 2factor auth' do
        expect(page).to have_content('To sign up, you will need to verify your account')
      end
    end


    context 'when setting a 2factor phone number' do
      before {
        fill_in('Phone number', with: '0423456789')
        click_button('Send code')
      }


      it 'gives me a field to enter my code' do
        expect(page).to have_content('A text message with a verification code was just sent to')
        expect(page).to have_content('**** *** *89')
      end

      it 'has not yet set my phone number' do
        u = User.find_by(email: 'test@example.gov.au')
        expect(u.phone_number).to eq(nil)
        expect(u.unconfirmed_phone_number).to eq('0423456789')
      end


      context 'verifying my code' do
        before {
          u = User.find_by(email: 'test@example.gov.au')
          fill_in('Enter 6 digit code', with: u.unconfirmed_phone_number_otp)
          click_button('Verify')
        }


        it 'saves the number' do
          u = User.find_by(email: 'test@example.gov.au')
          expect(page).to have_content('You have successfully verified and saved your phone number')
          expect(u.phone_number).to eq('0423456789')
          expect(u.unconfirmed_phone_number).to eq(nil)
          expect(u.account_verified).to eq(true)
        end
      end
    end
  end
end
