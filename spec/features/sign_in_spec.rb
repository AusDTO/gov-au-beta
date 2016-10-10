require 'rails_helper'

RSpec.describe 'signing in', type: :feature do
  Warden.test_mode!

  describe 'signing in as an unauthenticated user' do
    let!(:root_node) { Fabricate(:root_node) }
    let!(:user) { Fabricate(:user) }

    context 'when signing in' do
      before { visit new_user_session_path }

      it { expect(current_path).to eq(new_user_session_path) }
    end
  end
end