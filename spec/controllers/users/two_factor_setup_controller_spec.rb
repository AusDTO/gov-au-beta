require 'rails_helper'

RSpec.describe Users::TwoFactorSetupController, type: :controller do
  render_views


  let!(:user) { Fabricate(:user, account_verified: nil, bypass_tfa: false) }
  let!(:complete_user) { Fabricate(:user, account_verified: true, bypass_tfa: false) }

  describe 'post #choice for complete user' do
    before {
      sign_in(complete_user)
    }

    subject { post :choice }

    it { expect(subject).to redirect_to root_path }
  end


  describe 'post #choice' do
    before {
      sign_in(user)
    }

    context 'with sms and authenticator' do
      subject {
        post :choice, params: { validation: { sms: '1', authenticator: '1'}}
      }

      it 'should modify session var' do
        subject
        expect(session[:setup_2fa]).to match(['authenticator'])
      end

      it { expect(subject).to redirect_to new_users_two_factor_setup_sms_path }
    end


    context 'with sms' do
      subject {
        post :choice, params: { validation: { sms: '1'} }
      }

      it 'should modify session var' do
        subject
        expect(session[:setup_2fa]).to eq([])
      end

      it { expect(subject).to redirect_to new_users_two_factor_setup_sms_path }
    end


    context 'with authenticator' do
      subject {
        post :choice, params: { validation: { authenticator: '1' } }
      }

      it 'should modify session var' do
        subject
        expect(session[:setup_2fa]).to eq([])
      end

      it { expect(subject).to redirect_to new_users_two_factor_setup_authenticator_path }
    end
  end
end