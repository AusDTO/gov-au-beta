require 'rails_helper'


RSpec.describe Users::TwoFactorVerificationController, type: :controller do
  render_views

  let!(:root_node) { Fabricate(:root_node) }
  let!(:user) {
    Fabricate(:user, bypass_tfa: false, confirmed_at: Time.now.utc,
              phone_number: '0423456789', account_verified: true)
  }

  let!(:totp_user) {
    Fabricate(:totp_user, bypass_tfa: false, confirmed_at: Time.now.utc,
              phone_number: '0423456789', account_verified: true)
  }


  describe 'post #create' do
    subject { post :create }

    context 'with a non-totp user' do
      before { sign_in(user) }

      it {
        expect { subject }.to change {
          User.find(user.id).direct_otp
        }
      }

      it {
        expect { subject }.to change {
          User.find(user.id).direct_otp_sent_at
        }
      }

      it { expect(subject).to redirect_to confirm_users_two_factor_verification_path }
    end


    context 'with a totp user' do
      before { sign_in(totp_user) }

      it {
        expect { subject }.to_not change {
          User.find(user.id).direct_otp
        }
      }

      it { expect(subject).to redirect_to confirm_users_two_factor_verification_path }

      context 'with an expired otp' do
        before {
          totp_user.direct_otp = '123456'
          totp_user.direct_otp_sent_at = 10.minutes.ago
          totp_user.save
        }

        it {
          expect { subject }.to change {
            User.find(totp_user.id).direct_otp
          }.from('123456').to(nil)
        }
      end
    end
  end


  describe 'get #confirm' do
    subject { get :confirm }

    context 'with any user with an expired otp' do
      before {
        sign_in(user)
        user.direct_otp = '123456'
        user.direct_otp_sent_at = 10.minutes.ago
        user.save
      }

      it {
        expect { subject }.to change {
          User.find(user.id).direct_otp
        }.from('123456').to(nil)
      }
    end
  end


  describe 'post #update' do
    context 'with a valid otp code' do
      before {
        sign_in(totp_user)
        totp_user.create_direct_otp_for(:direct_otp)
      }

      subject {
        post :update, params: { code: User.find(totp_user.id).direct_otp }
      }

      it { expect(subject).to redirect_to root_path }

      it 'should set a success message' do
        subject
        expect(flash[:notice]).to be_present
      end

      context 'with an intercepted path' do
        before {
          session[:target_redirect] = '/users'
        }

        it { expect(subject).to redirect_to '/users' }
      end
    end


    context 'with a valid totp code' do
      before {
        sign_in(totp_user)
      }

      subject {
        post :update, params: { code: ROTP::TOTP.new('averysecretkey').now }
      }

      it { expect(subject).to redirect_to root_path }

      it 'should set a success message' do
        subject
        expect(flash[:notice]).to be_present
      end

      context 'with an intercepted path' do
        before {
          session[:target_redirect] = '/users'
        }

        it { expect(subject).to redirect_to '/users' }
      end
    end


    context 'with an invalid code' do
      before { sign_in(user) }

      subject { post :update }

      it 'should set an error' do
        subject
        expect(flash[:alert]).to be_present
      end

      it { expect(subject).to redirect_to confirm_users_two_factor_verification_path }
    end
  end


  describe 'post #resend_code' do
    context 'for any user' do
      before { sign_in(user) }
      subject { post :resend_code }

      it { expect(subject).to redirect_to confirm_users_two_factor_verification_path }

      it {
        expect { subject }.to change {
          User.find(user.id).direct_otp
        }
      }

      it {
        expect { subject }.to change {
          User.find(user.id).direct_otp_sent_at
        }
      }
    end
  end
end

