require 'rails_helper'

RSpec.describe 'invite', type: :feature do

  Warden.test_mode!

  let!(:root_node) { Fabricate(:root_node) }
  let!(:invite) { Fabricate(:invite, code: 'acode') }
  let(:admin) { Fabricate(:user, is_admin: true) }

  context 'when enabled' do
    before do
      allow(Rails.configuration).to receive(:require_invite) { true }
    end

    context 'when unauthorized visitor' do
      context 'visiting /' do
        before do
          visit '/'
        end

        it 'should redirect to show invite required' do
          expect(page.current_path).to eq(required_invites_path)
        end
      end

      context 'when visiting sign_in' do
        before do
          visit new_user_session_path
        end

        it 'should not redirect' do
          expect(page.current_path).to eq(new_user_session_path)
        end
      end

      context 'when accepting a valid invite' do
        before do
          visit invite_path(invite)
        end

        it { expect(page).to have_button('Accept invite') }

        it 'clicking accept redirects to /' do
          click_button('Accept invite')
          expect(page.current_path).to eq('/')
        end
      end
    end

    context 'when signed in' do
      before do
        login_as(admin, scope: :user)
        visit '/'
      end

      it 'should not redirect' do
        expect(page.current_path).to eq('/')
      end
    end
  end

  context 'when logged in' do
    before do
      login_as(admin, scope: :user)
    end

    context 'when creating invite' do
      before do
        visit new_invite_path
      end

      it 'creates invite' do
        expect(page).to have_content('Send an invite')
        fill_in('Email', with: 'foo@example.gov.au')
        click_button('Send invite')
        expect(page).to have_content('Invite has been sent')
      end
    end
  end

  context 'when disabled and visiting show invite' do
    before do
      visit invite_path(invite)
    end

    it 'redirects to /' do
      expect(page.current_path).to eq('/')
    end
  end
end
