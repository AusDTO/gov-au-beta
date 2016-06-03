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

end
