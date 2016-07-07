require 'rails_helper'

RSpec.describe "section features", :type => :feature do
  context 'a section' do
    let(:root) { Fabricate(:section, name: "root")}
    let!(:nodeA) { Fabricate(:node, name: "nodeA", section: root) }
    let!(:nodeB) { Fabricate(:node, name: "nodeB", section: root) }

    it 'should render the links to nodes in that section' do
      visit section_path(root)
      within('article') do
        expect(find_link(nodeA.name)[:href]).to eq(nodes_path(section: nodeA.section, path: nodeA.path))
        expect(find_link(nodeB.name)[:href]).to eq(nodes_path(section: nodeB.section, path: nodeB.path))
      end
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
    end

    context 'when a node is in state' do
      let!(:one) { Fabricate(:node, name: 'blah', state: 'published', section: root) }
      let!(:two) { Fabricate(:node, name: 'vtha', state: 'draft', section: root) }

      it 'navigation does not display draft node' do
        visit section_path(root)
        within('nav.primary-nav') do
          expect(find_link(one.name)[:href]).to eq(nodes_path(section: one.section, path: one.path))
          expect{ find_link(two.name)[:href] }.to raise_error Capybara::ElementNotFound
        end
        within('article') do
          expect(find_link(one.name)[:href]).to eq(nodes_path(section: one.section, path: one.path))
          expect{ find_link(two.name)[:href] }.to raise_error Capybara::ElementNotFound
        end

      end

    end
  end
end
