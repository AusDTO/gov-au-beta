require 'rails_helper'

RSpec.describe 'admin features', type: :feature do

  describe 'home page sidebar links' do
    let!(:agency) { Fabricate(:agency) }
    let!(:topic) { Fabricate(:topic) }

    before do 
      visit '/admin'
    end

    it 'should show links to administer section types' do
      expect(sidebar.find_link('Agencies')[:href]).to eq '/admin/agencies'
      expect(sidebar.find_link('Topics')[:href]).to eq '/admin/topics'
    end

    it 'should not show a link to administer sections en masse' do
      expect(sidebar).not_to have_link 'Sections'
    end

    it 'should not show links to nodes or content blocks' do
      expect(sidebar).not_to have_link 'Nodes'
      expect(sidebar).not_to have_link 'Content Blocks'
    end

    it 'should show agencies by default' do
      expect(page).to have_content agency.name
    end

    def sidebar
      find('.sidebar')
    end

  end

end