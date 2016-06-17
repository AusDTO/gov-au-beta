require 'rails_helper'

RSpec.describe Editorial::RequestsController, type: :controller do
  describe '#new' do

    let(:section) { Fabricate(:section) }
    let(:author) { Fabricate(:user, author_of: section) }
    let(:alt_section) { Fabricate(:section) }
    let!(:request) { Fabricate(:request, user: author, section: alt_section, state: 'requested')}

    describe 'creating a new request' do

      context 'when logged in for an existing section' do
        before do
          sign_in(author)
          get :new, section: section.id
        end

        it { is_expected.to respond_with 200 }
        it { is_expected.to assign_to(:section).with section }
        it { is_expected.to assign_to(:form) }
        it { is_expected.to assign_to(:owners).with User.with_role(:owner, section)}
      end

      context 'when logged in for nonexistent section' do
        before do
          sign_in(author)
        end

        it 'throws an exception' do
          expect {
            get :new, section: '99999'
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    describe 'creating a request where one exists already' do

      context 'when logged in for a section already requested of' do
        before do
          sign_in(author)
          get :new, section: alt_section.id
        end

        it { is_expected.to set_flash[:notice] }
        it { is_expected.to respond_with 302 }
      end
    end

  end

  describe '#create' do

    let(:section) { Fabricate(:section) }
    let(:author) { Fabricate(:user, author_of: section) }
    let(:alt_section) { Fabricate(:section)}
    let!(:request) { Fabricate(:request, user: author, section: alt_section, state: 'requested') }

    context 'when section doesn\'t exist' do
      before do
        sign_in(author)
      end

      it 'redirects to root path' do
        post :create, { request: { section_id: '9999' } }
        response.should redirect_to root_path
      end
    end


    context 'when section is valid' do
      before do
        sign_in(author)
      end

      it 'create new request' do
        expect {
          post :create, { request: { section_id: section.id } }
        }.to change(Request, :count).by(1)
      end

      it 'redirects to new request' do
        post :create, { request: { section_id: section.id } }
        response.should redirect_to editorial_request_path(Request.last)
      end
    end

    context 'when section already has been requested' do
      before do
        sign_in(author)
      end

      it 'new request not created' do
        expect {
          post :create, { request: { section_id: alt_section.id } }
        }.to change(Request, :count).by(0)
      end

      it 'redirects to existing request' do
        post :create, { request: { section_id: alt_section.id } }
        response.should redirect_to editorial_request_path(request.id)
      end
    end

    context 'when section is invalid' do
      before do
        sign_in(author)
      end

      it 'redirects to root path' do
        post :create, { request: { foo: :bar } }
        response.should redirect_to root_path
      end
    end

  end

  describe '#show' do
    let(:section) { Fabricate(:section) }
    let(:author) { Fabricate(:user, author_of: section) }
    let!(:request) { Fabricate(:request, user: author, section: section, state: 'requested') }
    
    context 'when viewing an existing request' do
      before do
        sign_in(author)
        get :show, params: { id: request.id }
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to assign_to(:rqst).with request }
      it { is_expected.to assign_to(:owners).with User.with_role(:owner, section) }

      it 'renders the show template' do
        response.should render_template :show
      end
    end

    context 'when viewing a nonexistent request' do
      before do
        sign_in(author)
      end

      it 'raises an error' do
        expect {
          get :show, params: { id: '9999' }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

    end
  end
end