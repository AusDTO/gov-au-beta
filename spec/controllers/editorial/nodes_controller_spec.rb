require 'rails_helper'

RSpec.describe Editorial::NodesController, type: :controller do

  describe 'GET #index' do
    let(:section) { Fabricate(:section) }
    let(:nodes) { Fabricate.times(3, :node, section: section) }

    before do
      get :index, params: { section: section.slug }
    end

    it { is_expected.to assign_to(:section).with section }
    it { is_expected.to assign_to(:nodes).with section.nodes.decorate }
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
