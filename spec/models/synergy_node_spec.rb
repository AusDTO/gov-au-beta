require 'rails_helper'

RSpec.describe SynergyNode, type: :model do

  describe '#path' do
    let(:root)    { SynergyNode.create!(slug: '', source_name: "foo") }
    let(:parent)  { root.children.create!(slug: 'blah', source_name: "foo") }
    let(:node)    { parent.children.create!(slug: 'vtha', source_name: "foo") }

    it 'should generate the correct path' do
      expect(node.path).to eq('/blah/vtha')
    end
  end

end
