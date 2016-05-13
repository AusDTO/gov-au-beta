require 'rails_helper'

RSpec.describe "section features", :type => :feature do
  context 'a section' do
    let(:root) { Fabricate(:section, name: "root")}
    let!(:nodeA) { Fabricate(:node, name: "nodeA", uuid:"uuid_nodeA", section: root) }
    let!(:nodeB) { Fabricate(:node, name: "nodeB", uuid:"uuid_nodeB", section: root) }

    it 'should render the links to nodes in that section' do
      visit sections_path(root)
      expect(find_link(nodeA.name)[:href]).to eq(sections_path(nodeA.section) +nodes_path(nodeA))
      expect(find_link(nodeB.name)[:href]).to eq(sections_path(nodeB.section) +nodes_path(nodeB))
    end
  end
end