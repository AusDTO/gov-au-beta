require 'rails_helper'

RSpec.describe Editorial::SectionsController, type: :controller do

  describe 'GET #index' do
    let(:author) { Fabricate(:user, is_author: true) }
    let(:reviewer) { Fabricate(:user, is_reviewer: true) }
    let(:authenticated_request) { get :index }

    context 'when user is authorised' do
      before do
        sign_in(author)
        authenticated_request
      end

      after do
        sign_out(author)
      end

      let! (:section_b) { Fabricate(:section, name: "b") }
      let! (:section_a) { Fabricate(:section, name: "a") }

      it { is_expected.not_to set_flash[:alert] }

      it "should assign @sections" do
        expect(assigns(:sections)).to eq([section_a, section_b])
      end
    end

    context 'when user is not authorised' do
      before do
        sign_in(reviewer)
        authenticated_request
      end

      after do
        sign_out(reviewer)
      end

      it { is_expected.to set_flash[:alert].to("You are not authorized to access this page.") }

    end

    context 'when user is not authenticated' do
      before do
        authenticated_request
      end

      it { is_expected.to set_flash[:alert].to("You are not authorized to access this page.") }

    end
  end
end
