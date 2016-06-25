require 'rails_helper'

RSpec.describe "section features", :type => :feature do
  context 'a section' do
    let(:root) { Fabricate(:section, name: "root")}
    let!(:nodeA) { Fabricate(:node, name: "nodeA", section: root) }
    let!(:nodeB) { Fabricate(:node, name: "nodeB", section: root) }

    it 'should render the links to nodes in that section' do
      visit section_path(root)
      expect(find_link(nodeA.name)[:href]).to eq(nodes_path(section: nodeA.section, path: nodeA.path))
      expect(find_link(nodeB.name)[:href]).to eq(nodes_path(section: nodeB.section, path: nodeB.path))
    end

    it 'should render the links to the sections from the root page' do
      visit '/'
      expect(find_link(root.name)[:href]).to eq(section_path(root))
    end

    context 'when signed in' do
      let (:user) { Fabricate(:user) }
      before do
        login_as(user)
      end

      context 'a topic page' do
        before do
          visit section_path(Fabricate(:topic))
        end
        it 'shows a request membership link' do
          expect(page.body).to have_content(/request/i)
        end
      end

      context 'an agency page' do
        before do
          visit section_path(Fabricate(:agency))
        end
        it 'does not show request membership link' do
          expect(page.body).not_to have_content(/request/i)
        end
      end
    end
  end
end
