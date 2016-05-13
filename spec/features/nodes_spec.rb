require 'rails_helper'

RSpec.describe "node features", :type => :feature do

  context 'a node with a uuid link' do
    let(:root) { Fabricate(:section, name: "root")}
    let!(:node) { Fabricate(:node, name: "nodeA", uuid:"uuid_nodeA", section: root) }

    let(:linking_content) { Fabricate(:content_block, unique_id: "uuid_cb", body: '<a href="/invalid" data-uuid="uuid_nodeA">My link</a>')}
    let!(:linking_node) { Fabricate(:node, name: "nodeB", uuid:"uuid_nodeB", section: root, content_block: linking_content) }

    it 'should render the link' do
      visit "/root/nodeb"
      expect(find_link('My link')[:href]).to eq('/root/nodea')
      visit find_link('My link')[:href]
      expect(page).to have_content("nodeA")
    end
  end

end