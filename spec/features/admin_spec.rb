require 'rails_helper'

RSpec.describe 'admin features', type: :feature do

  describe 'home page sidebar links' do 
    before do 
      visit '/admin'
    end

    it 'should show links to administer section types' do
      expect(find_link('Agencies')[:href]).to eq '/admin/agencies'
      expect(find_link('Topics')[:href]).to eq '/admin/topics'
    end

    it 'should not show a link to administer sections en masse' do
      expect(has_link?('Sections')).to be false
    end

    it 'should not show links to nodes or content blocks' do
      expect(has_link?('Nodes')).to be false
      expect(has_link?('Content Blocks')).to be false
    end
  end

end