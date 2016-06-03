require 'rails_helper'

RSpec.describe 'editing content', type: :feature do

  context 'on a node page' do
    let!(:node) { Fabricate(:node) }

    it 'should show a link to edit the content in the CMS' do
      visit "/#{node.section.slug}/#{node.slug}"
      expect(page).to have_link('Edit this page')
    end
  end

  context 'on a section page' do
    let!(:section) { Fabricate(:section) }

    it 'should not show an edit link' do
      visit "/#{section.slug}"
      expect(page).not_to have_link('Edit this page')
    end
  end

end