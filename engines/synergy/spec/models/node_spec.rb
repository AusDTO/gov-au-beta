require 'rails_helper'

RSpec.describe Synergy::Node, type: :model do

  describe '#path' do
    let(:root)    { Synergy::Node.create!(slug: '') }
    let(:parent)  { root.children.create!(slug: 'blah') }
    let(:node)    { parent.children.create!(slug: 'vtha') }

    it 'should generate the correct path' do
      expect(node.path).to eq('/blah/vtha')
    end
  end

end
