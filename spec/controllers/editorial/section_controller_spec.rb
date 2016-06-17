require 'rails_helper'

RSpec.describe Editorial::SectionsController, type: :controller do
  describe 'GET #show' do
    let(:user) { Fabricate(:user) }
    let(:section) { Fabricate(:section) }
    before :example do
      sign_in(user)
    end

    context 'when user is authenticated and views all pages filter' do
      # before do
      #   sign_in(user)
      # end

      it 'should load the page' do
        get :show, section: section.slug
        expect(response.status).to eq(200)
        expect(assigns(:filter)).to eq(nil)
      end
    end

    context 'when an authenticated user views submission filter' do
      it 'should load the page' do
        get :show, section: section.slug, filter: 'submissions'
        expect(response.status).to eq(200)
        expect(assigns(:filter)).to eq('submissions')
      end
    end

    context 'when an authenticated user views my_pages filter' do
      it 'should load the page' do
        get :show, section: section.slug, filter: 'my_pages'
        expect(response.status).to eq(200)
        expect(assigns(:filter)).to eq('my_pages')
      end
    end

    context 'when an authenticated user views a non-existent filter' do
      it 'should load the page without a filter' do
        get :show, section: section.slug, filter: 'not a filter'
        expect(response.status).to eq(200)
        expect(assigns(:filter)).to eq(nil)
      end
    end
  end
end