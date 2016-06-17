require 'rails_helper'

RSpec.describe Editorial::EditorialController, type: :controller do

  describe 'GET #index' do
    let(:user) { Fabricate(:user) }
    let(:authenticated_request) { get :index }

    context 'when user is logged in' do
      before do
        sign_in(user)
        authenticated_request
      end

      after do
        sign_out(user)
      end

      let! (:section_b) { Fabricate(:section, name: "b") }
      let! (:section_a) { Fabricate(:section, name: "a") }

      it { is_expected.not_to set_flash[:alert] }

      it "should assign @sections" do
        expect(assigns(:sections)).to eq([section_a, section_b])
      end
    end

    context 'when user is not authenticated' do
      before do
        authenticated_request
      end

      it { is_expected.to set_flash[:alert].to("You are not authorized to access this page.") }

    end
  end


end
