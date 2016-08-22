require 'rails_helper'

RSpec.describe InvitesController, type: :controller do
  render_views

  include ActiveJob::TestHelper
  let!(:root_node) { Fabricate(:root_node) }
  let(:admin) { Fabricate(:user, is_admin: true) }

  context 'when invites enabled' do
    before do
      allow(Rails.configuration).to receive(:require_invite) { true }
    end

    describe 'GET #required' do
      before do
        get :required
      end
      it { is_expected.not_to render_with_layout :application }
    end

    describe 'GET #show' do
      context 'when invite is valid' do
        let!(:invite) { Fabricate(:invite, code: 'acode') }
        before do
          get :show, params: {id: invite.code}
        end

        it { expect(assigns(:invite)).to eq(invite) }

        it { expect(response).to render_template(:show) }

        it { is_expected.not_to render_with_layout :application }
      end

      context 'when invite is not valid' do
        it do
          expect {
            get :show, params: {id: 'bad'}
          }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    describe 'GET #new' do
      context 'when logged in' do
        before do
          sign_in(admin)
          get :new
        end
        it { expect(response).to have_http_status(:success) }
        it { is_expected.to render_template :new }
      end

      context 'when not logged in' do
        before do
          get :new
        end
        it { expect(response).to have_http_status(:redirect) }
      end
    end

    describe 'POST #create' do
      subject(:perform) { post :create, params: {invite: params} }

      context 'when logged in' do
        before do
          sign_in(admin)
        end

        context 'with valid params' do
          let(:params) do
            {
                email: 'foo@bar.com'
            }
          end

          specify 'that a record is created' do
            expect { subject }.to change(Invite, :count).by(1)
          end

          it 'sends an email notification' do
            perform_enqueued_jobs do
              expect { subject }.to change(ActionMailer::Base.deliveries, :count).by(1)
            end
          end

          describe 'the created invite' do
            before { perform }
            subject { Invite.last }

            its(:email) { is_expected.to eq(params[:email]) }
          end
        end

        context 'with invalid params' do
          let(:params) { {email: 'foo'} }

          specify 'that a record is NOT created' do
            expect { subject }.to_not change(Invite, :count)
          end
        end
      end

      context 'when not logged in' do
        context 'with valid params' do
          let(:params) { {email: 'valid@gov.au'} }

          specify 'that a record is NOT created' do
            expect { subject }.to_not change(Invite, :count)
          end
        end
      end
    end

    describe 'PUT #update/:id' do
      subject(:perform) { put :update, params: params }

      context 'with valid params' do
        before do
          perform
          invite.reload
        end
        let(:invite) { Fabricate(:invite, code: 'acode') }
        let(:params) { {id: invite.code} }
        it { expect(response.cookies[Invite::COOKIE_NAME]).to eq(invite.accepted_token) }
      end

      context 'with invalid params' do
        let(:params) { {id: 'badcode'} }
        it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
      end
    end
  end

  context 'when invites disabled' do
    before do
      allow(Rails.configuration).to receive(:require_invite) { false }
    end
    describe 'GET #show' do
      before do
        get :show, params: {id: 'notused'}
      end
      it 'should redirect' do
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
