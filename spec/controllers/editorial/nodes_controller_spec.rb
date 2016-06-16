require 'rails_helper'

RSpec.describe Editorial::NodesController, type: :controller do

  describe 'GET #index' do

    let(:author) { Fabricate(:user, is_author: true) }
    let(:reviewer) { Fabricate(:user, is_reviewer: true) }
    let(:section) { Fabricate(:section) }
    let(:nodes) { Fabricate.times(3, :node, section: section) }
    let(:authenticated_request) { get :index, params: { section_id: section.id } }

    context 'when user is authorised' do
      before do
        sign_in(author)
        authenticated_request
      end

      after { sign_out(reviewer) }

      it { is_expected.to assign_to(:section).with section }
      it { is_expected.to assign_to(:nodes).with section.nodes.decorate }
    end

    context 'when user is not authorised' do
      before { authenticated_request }

      it { is_expected.to set_flash[:alert].to("You are not authorized to access this page.") }
    end

    context 'when user is a reviewer' do
      before { sign_in(reviewer) }
      after { sign_out(reviewer) }

      it { is_expected.not_to set_flash[:alert] }
    end

    context 'when user is an author' do
      before { sign_in(author) }
      after { sign_out(author) }

      it { is_expected.not_to set_flash[:alert] }
    end

    # context 'when no section ID is specified' do
    #   before do
    #     sign_in author
    #     get :index
    #   end
    #
    #   it { is_expected.to redirect_to '/editorial' }
    # end
  end

end
