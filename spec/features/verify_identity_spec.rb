require 'rails_helper'
require 'support/shared_context_two_factor_login.rb'

RSpec.describe 'verify identity', type: :feature do
  Warden.test_mode!

  let!(:root_node) { Fabricate(:root_node) }
  let!(:otp_user) {
    Fabricate(:user, bypass_tfa: false, account_verified: true)
  }

  let!(:totp_user) {
    Fabricate(:totp_user, bypass_tfa: false, account_verified: true)
  }

  describe 'verification with no more attempts' do
    include_context 'shared_two_factor_login'

    let!(:user) {
      Fabricate(:user, bypass_tfa: false, account_verified: true,
                phone_number: '0423456789')
    }

    before {
      login_as(user)
      complete_2fa_login(user)
      visit new_users_two_factor_setup_sms_path
      click_link('Continue')

      Rails.configuration.devise.max_login_attempts.times do
        fill_in('Enter 6 digit code', with: 'nocode')
        click_button('Verify')
      end
    }

    context 'verifying self' do
      it 'should lock user out' do
        expect(page).to have_content 'Access completely denied as you have reached your attempts'
      end
    end
  end


  describe 'two_factor_verification' do
    include_context 'shared_two_factor_login'

    context 'with a otp_user' do
      before {
        login_as(otp_user)
        complete_2fa_login(otp_user)
      }

      context 'when accessing a protected area' do
        before { visit new_users_two_factor_setup_sms_path }

        it 'should redirect to user verification' do
          expect(current_path).to eq(new_users_two_factor_verification_path)
          expect(page).to have_content(
            'We need to quickly check this is you'
          )
          expect(page).to have_link('Continue')
        end


        context 'when following start link' do
          before { click_link('Continue') }

          it 'should show a code input' do
            expect(page).to have_field('Enter 6 digit code')
            expect(page).to have_content(
              'A verification code was just sent to the mobile '
            )
          end


          context 'with the incorrect code' do
            before {
              fill_in('Enter 6 digit code', with: 'wrongcode')
              click_button('Verify')
            }

            it 'should show an error' do
              expect(page).to have_content("Sorry, your code didn't work. Please try again.")
              expect(page).to have_field('Enter 6 digit code')
            end
          end


          context 'with the correct code' do
            before {
              fill_in('Enter 6 digit code', with: User.find(otp_user).direct_otp)
              click_button('Verify')
            }


            it 'should display the original view' do
              expect(current_path).to eq(new_users_two_factor_setup_sms_path)
              expect(page).to have_content('Thanks. You account has been verified.')
            end
          end
        end

      end
    end
  end
end

