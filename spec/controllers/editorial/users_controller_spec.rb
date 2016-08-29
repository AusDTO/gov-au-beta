require 'rails_helper'

RSpec.describe Editorial::UsersController, type: :controller do
  include ActiveJob::TestHelper

  let!(:section) { Fabricate(:section) }
  let(:owner) { Fabricate(:user, owner_of: section) }

  before do
    sign_in(owner)
  end

  describe '#new' do
    subject { get :new }

    it { is_expected.to be_success }
  end

  describe '#create' do
    subject { post :create, params: {user: params} }

    shared_examples 'succeed' do
      it { is_expected.to redirect_to(editorial_root_path) }

      it 'creates the user' do
        expect { subject }.to change(User, :count).by(1)
      end

      it 'sends an email notification' do
        perform_enqueued_jobs do
          expect { subject }.to change(ActionMailer::Base.deliveries, :count).by(1)
        end
      end
    end

    context 'with valid params' do
      let(:params) {{email: 'real@foo.gov.au', first_name: 'First', last_name: 'Last'}}

      include_examples 'succeed'
    end

    context 'without name' do
      let(:params) {{email: 'real@foo.gov.au'}}

      include_examples 'succeed'
    end

    context 'with invalid email' do
      let (:params) {{email: 'bad@bad'}}

      it 'does not create the user' do
        expect { subject }.not_to change(User, :count)
      end
    end
  end

end
