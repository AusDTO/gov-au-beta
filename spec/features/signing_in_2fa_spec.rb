require 'rails_helper'

RSpec.describe 'signing in 2fa', type: :feature do
  Warden.test_mode!
  ActiveJob::Base.queue_adapter = :test

  let!(:root_node) { Fabricate(:root_node) }
  let!(:otp_user) { Fabricate(:user, bypass_tfa: false) }
  let!(:totp_user) { Fabricate(:totp_user, bypass_tfa: false) }


  describe 'two factor authentication as admin' do
    let!(:admin) { Fabricate(:user, is_admin: true, bypass_tfa: false) }

    context 'when logging in' do
      before{
        login_as(admin)
        visit admin_root_path
      }


      it 'should force user to do 2fa' do
        expect(page).to have_content('Enter the code that was sent to you')
        expect(page).to have_field('Enter 6 digit code')
      end
    end

  end


  describe 'two factor authentication as otp user' do
    subject {
      login_as(otp_user)
      # Need to navigate somewhere to trigger 2fa login for tests
      visit root_path
    }

    it {
      expect{ subject }.to have_enqueued_job(SendTwoFactorAuthenticationCodeJob)
    }

    context 'with a sent code' do
      before { subject }

      it 'should ask for code input' do
        expect(page).to have_content('Enter the code that was sent to you')
        expect(page).to have_field('Enter 6 digit code')
      end


      it 'should provide a resend link' do
        expect(page).to have_link('Resend now')
      end

      context 'with the incorrect code' do
        before {
          fill_in('Enter 6 digit code', with: '000000')
          click_button('Verify')
        }

        it 'should return an error' do
          expect(page).to have_content('Attempt failed.')
          expect(page).to have_field('Enter 6 digit code')
        end
      end


      context 'with the correct code' do

        before {
          fill_in('Enter 6 digit code', with: User.find(otp_user).direct_otp)
          click_button('Verify')
        }

        it 'should redirect to root' do
          expect(current_path).to eq(root_path)
          expect(page).to have_link('Sign out')
        end
      end
    end
  end

  describe 'two factor authentication as totp user' do
    before {
      login_as(totp_user)
      # Need to navigate somewhere to trigger 2fa login for tests
      visit root_path
    }

    it 'should ask for authenticator code' do
      expect(page).to have_field('Enter 6 digit code')
      expect(page).to have_content('Enter the code from your authenticator app')
    end

    it 'should provide a link to an sms code' do
      expect(page).to have_link('Send me a code instead')
    end

    context 'with the wrong code' do
      before {
        fill_in('Enter 6 digit code', with: 'notacode')
        click_button('Verify')
      }


      it 'should return an error' do
        expect(page).to have_content('Attempt failed.')
        expect(page).to have_field('Enter 6 digit code')
      end
    end

    context 'with the correct code' do
      before {
        # Code defined in fabricators/users.rb
        fill_in('Enter 6 digit code', with: ROTP::TOTP.new('averysecretkey').now)
        click_button('Verify')
      }

      it 'shoould login user' do
        expect(current_path).to eq(root_path)
        expect(page).to have_content(totp_user.email)
      end
    end

    context 'with sms requested instead' do
      subject {
        click_link('Send me a code instead')
      }

      it {
        expect{ subject }.to have_enqueued_job(SendTwoFactorAuthenticationCodeJob)
      }

      context 'with a sent code' do
        before { subject }

        it 'ask for sms code input' do
          expect(page).to have_content('Enter the code that was sent to you')
        end

        context 'with the correct code' do
          before {
            fill_in('Enter 6 digit code', with: User.find(totp_user).direct_otp)
            click_button('Verify')
          }


          it 'should login user' do
            expect(current_path).to eq(root_path)
            expect(page).to have_content(totp_user.email)
          end
        end
      end
    end
  end
end

