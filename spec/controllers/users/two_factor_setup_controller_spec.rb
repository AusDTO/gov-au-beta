require 'rails_helper'

RSpec.describe Users::TwoFactorSetupController, type: :controller do
  render_views

  let!(:root_node) { Fabricate(:root_node) }
  let!(:incomplete_user) {
    Fabricate(:user, bypass_tfa: false, confirmed_at: Time.now.utc,
              phone_number: nil, account_verified: false)
  }

  let!(:valid_authenticate_request) {
    stub_request(:post, Rails.configuration.sms_authenticate_url).
        with(:body => {"client_id"=>"", "client_secret"=>"", "grant_type"=>"client_credentials", "scope"=>"SMS"},
             :headers => {'Content-Type'=>'application/x-www-form-urlencoded'}).
        to_return(:status => 200, :body => '{"access_token":"somereallyspecialtoken", "expires_in":"3599"}', :headers => {})
  }

  let!(:send_sms_request) {
    stub_request(:post, Rails.configuration.sms_send_message_url).
        with(:headers => {'Authorization'=>'Bearer somereallyspecialtoken', 'Content-Type'=>'application/json'}).
        to_return(:status => 200, :body => "", :headers => {})
  }

  describe 'post #create' do
    context 'with a valid phone number' do
      before { sign_in(incomplete_user) }

      subject {
        post :create, params: { phone_number: '0423456789' }
      }

      it { expect(subject).to redirect_to confirm_users_two_factor_setup_path }

      it {
        expect { subject }.to change {
          User.find(incomplete_user.id).unconfirmed_phone_number_otp
        }
      }
      it {
        expect { subject }.to change {
          User.find(incomplete_user.id).unconfirmed_phone_number_otp_sent_at
        }
      }

      it 'sets the users unconfirmed number' do
        expect { subject }.to change {
          User.find(incomplete_user.id).unconfirmed_phone_number
        }.from(nil).to('0423456789')
      end
    end


    context 'with an invalid phone number' do
      before { sign_in(incomplete_user) }

      subject {
        post :create
      }

      it 'errors' do
        expect(subject).to render_template :new
        expect(flash[:alert]).to be_present
      end

      it 'does not change the users unconfirmed number' do
        expect { subject }.to_not change {
          User.find(incomplete_user.id).unconfirmed_phone_number
        }
        expect { subject }.to_not change {
          User.find(incomplete_user.id).unconfirmed_phone_number_otp
        }
        expect { subject }.to_not change {
          User.find(incomplete_user.id).unconfirmed_phone_number_otp_sent_at
        }
      end
    end
  end


  describe 'post #update' do
    before {
      sign_in(incomplete_user)
    }

    context 'with no code generated' do
      subject { post :update }

      it { expect(subject).to redirect_to new_users_two_factor_setup_path}
    end


    context 'with a correct code' do
      before {
        incomplete_user.unconfirmed_phone_number = '0423456789'
        incomplete_user.create_direct_otp_for(:unconfirmed_phone_number_otp)
      }

      subject {
        post :update, params: {
          code: User.find(incomplete_user.id).unconfirmed_phone_number_otp
        }
      }

      it {
        expect { subject }.to change {
          User.find(incomplete_user.id).phone_number
        }.to(incomplete_user.unconfirmed_phone_number)
      }

      it 'should set the account verified' do
        subject
        expect(User.find(incomplete_user.id).account_verified).to eq(true)
        expect(User.find(incomplete_user.id).unconfirmed_phone_number).to eq(nil)
        expect(User.find(incomplete_user.id).unconfirmed_phone_number_otp).to eq(nil)
        expect(User.find(incomplete_user.id).unconfirmed_phone_number_otp_sent_at).to eq(nil)
        expect(flash[:notice]).to be_present
      end
    end


    context 'with the incorrect code' do
      before {
        incomplete_user.unconfirmed_phone_number = '0423456789'
        incomplete_user.create_direct_otp_for(:unconfirmed_phone_number_otp)
      }

      subject {
        post :update
      }

      it {
        expect { subject }.to_not change {
          User.find(incomplete_user.id).phone_number
        }
      }

      it 'should render confirm template' do
        expect(subject).to render_template :confirm
        expect(flash[:alert]).to be_present
      end
    end
  end


  describe 'get #update' do
    before { sign_in(incomplete_user) }
    subject { get :confirm }

    context 'with no code generated' do

      it { expect(subject).to redirect_to new_users_two_factor_setup_path}
    end


    context 'with a code set' do
      before {
        incomplete_user.unconfirmed_phone_number = '0423456789'
        incomplete_user.create_direct_otp_for(:unconfirmed_phone_number_otp)
      }

      it { expect(subject).to render_template :confirm }
    end
  end
end