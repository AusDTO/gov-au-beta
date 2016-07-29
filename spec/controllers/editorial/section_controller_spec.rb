require 'rails_helper'

RSpec.describe Editorial::SectionsController, type: :controller do
  render_views

  let!(:section) { Fabricate(:section) }
  let!(:user) { Fabricate(:user, author_of: section) }

  describe 'GET #show' do

    before :example do
      sign_in(user)
    end

    context 'when user is authenticated and views all pages filter' do
      it 'should load the page' do
        get :show, section_id: section
        expect(response.status).to eq(200)
        expect(assigns(:filter)).to eq(nil)
      end
    end

    context 'when an authenticated user views submission filter' do
      it 'should load the page' do
        get :show, section_id: section, filter: 'submissions'
        expect(response.status).to eq(200)
        expect(assigns(:filter)).to eq('submissions')
      end
    end

    context 'when an authenticated user views my_pages filter' do
      it 'should load the page' do
        get :show, section_id: section, filter: 'my_pages'
        expect(response.status).to eq(200)
        expect(assigns(:filter)).to eq('my_pages')
      end
    end

    context 'when an authenticated user views a non-existent filter' do
      it 'should load the page without a filter' do
        get :show, section_id: section, filter: 'not a filter'
        expect(response.status).to eq(200)
        expect(assigns(:filter)).to eq(nil)
      end
    end
  end

  describe 'GET #collaborators' do
    #TODO DRY this test up

    context 'when an authenticated user' do
      before do
        sign_in(user)
      end

      context 'views collaborators' do
        let!(:author) { Fabricate(:user, author_of: section) }
        let!(:reviewer) { Fabricate(:user, reviewer_of: section) }
        let!(:other_section) { Fabricate(:section) }
        let!(:other_author) { Fabricate(:user, author_of: other_section) }

        it 'should only see this sections collaborators' do
          get :collaborators, section_id: section

          expect(response.status).to eq(200)
          expect(assigns(:users)).to match_array([user, author, reviewer])
        end
      end

      context 'views pending requests' do
        let!(:request) { Fabricate(:request, user: user, section: section, state: 'requested')}
        let!(:other_section) { Fabricate(:section) }
        let!(:other_request) { Fabricate(:request, user: user, section: other_section, state: 'requested')}
        let!(:rejected_request) { Fabricate(:request, user: user, section: section, state: 'rejected')}

        it 'should only see this sections pending requests' do
          get :collaborators, section_id: section

          expect(response.status).to eq(200)
          expect(assigns(:pending)).to eq([request])
        end
      end
    end
  end
end
