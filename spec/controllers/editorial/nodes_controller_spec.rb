require 'rails_helper'

RSpec.describe Editorial::NodesController, type: :controller do

  describe 'GET #index' do

    let(:author) { Fabricate(:user, is_author: true) }
    let(:reviewer) { Fabricate(:user, is_reviewer: true) }
    let(:section) { Fabricate(:section) }
    let(:nodes) { Fabricate.times(3, :node, section: section) }
    let(:authenticated_request) { get :index, params: { section: section.slug } }

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
  end

  shared_examples_for 'node preview' do
    it { is_expected.to assign_to(:node).with node }
    it { is_expected.to render_with_layout node.section.layout }
  end

  describe 'GET #show' do
    let(:node) { Fabricate(:node, state: state) }

    before do
      get :show, params: { token: node.token }
    end

    #TODO contexts with & without auth (once role-based authorisation ready)
    #     (should exhibit same behaviour)

    context 'draft node' do
      let(:state) { 'draft' }
      include_examples 'node preview'
    end

    context 'published node' do
      let(:state) { 'published' }
      include_examples 'node preview'
    end
  end

end
