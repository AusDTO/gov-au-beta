require 'rails_helper'

RSpec.describe 'verify identity', type: :feature do
  Warden.test_mode!

  let!(:root_node) { Fabricate(:root_node) }
  let!(:otp_user) { Fabricate(:user, bypass_tfa: false) }
  let!(:totp_user) { Fabricate(:totp_user, bypass_tfa: false) }

  let(:verify_otp_user) {
    code = User.find(otp_user.id).direct_otp
    fill_in('Enter 6 digit code', with: code)
    click_button('Verify')
  }

  let(:verify_totp_user) {
    code = ROTP::TOTP.new('averysecretkey').now
    fill_in('Enter 6 digit code', with: code)
    click_button('Verify')
  }

  describe 'two_factor_confirmation' do
    context 'as an otp user' do
      before {
        login_as(otp_user)
        visit new_users_two_factor_verification_path
        verify_otp_user
        click_link('Get started')
      }

      context 'with an incorrect identity code' do
        before {
          fill_in('Enter 6 digit code', with: '000000')
          click_button('Verify')
        }

        it 'stays on the same page' do
          expect(current_path).to eq(confirm_users_two_factor_verification_path)
          expect(page).to have_content('There was an error with the verification code.')
        end
      end

      context 'with a correct code' do
        before {
          code = User.find(otp_user.id).direct_otp
          fill_in('Enter 6 digit code', with: code)
          click_button('Verify')
        }

        it 'redirects to root path' do
          expect(current_path).to eq(root_path)
        end
      end

      context 'requesting a new code' do
        before{
          click_link('Resend now')
        }

        it 'expects to show code input' do
          expect(current_path).to eq(confirm_users_two_factor_verification_path)
        end
      end
    end


    context 'intercepting another action' do
      before {
        login_as(otp_user)
        visit new_users_two_factor_setup_path
        verify_otp_user
      }

      context 'with a correct code' do
        before {
          click_link('Get started')
          code = User.find(otp_user.id).direct_otp
          fill_in('Enter 6 digit code', with: code)
          click_button('Verify')
        }

        it 'redirects to intercepted page' do
          expect(current_path).to eq(new_users_two_factor_setup_path)
        end
      end
    end
  end
end

