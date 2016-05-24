require 'rails_helper'

describe NodeDashboard do
  describe '#display_resource' do
    let(:node) { Fabricate :node }

    it 'should show the node name' do
      expect(subject.display_resource(node)).to eq node.name
    end
  end
end
