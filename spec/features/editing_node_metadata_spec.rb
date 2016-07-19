require 'rails_helper'

RSpec.describe 'editing node metadata:', type: :feature do

  Warden.test_mode!
  let!(:root_node) { Fabricate(:root_node) }
  let!(:section) { Fabricate(:section) }
  let!(:author) { Fabricate(:user, author_of: section) }
  let!(:parent) { Fabricate(:general_content, parent: section.home_node) }
  let!(:child1) { Fabricate(:general_content, parent: parent) }
  let!(:child2) { Fabricate(:general_content, parent: parent) }
  let!(:child3) { Fabricate(:general_content, parent: parent) }

  before :each do
    login_as(author, scope: :user)
  end

  after do
    logout(:user)
  end

  context 'editing a parent node' do
    before do
      visit edit_editorial_section_node_path(section, parent)
    end

    it 'prefills the parent' do
      expect(page).to have_select('Parent', selected: section.home_node.name)
    end

    it 'shows the children order form' do
      expect(page).to have_content('Child menu order')
      parent.children.each do |child|
        expect(page).to have_content(child.name)
      end
    end

    context 'setting the child order' do
      it 'sets the child order' do
        fill_in(child1.name, with: 3)
        fill_in(child2.name, with: 1)
        fill_in(child3.name, with: 2)
        click_button('Edit')
        expect(page).to have_content(Regexp.new("#{child2.name}.*#{child3.name}.*#{child1.name}"))
      end
    end

    context 'setting invalid data' do
      it 'returns the error' do
        fill_in(child1.name, with: nil)
        click_button('Edit')
        expect(page).to have_content('can\'t be blank')
      end
    end
  end

  context 'editing a child' do
    before do
      visit edit_editorial_section_node_path(section, child1)
    end

    it 'prefills the parent' do
      expect(page).to have_select('Parent', selected: parent.name)
    end

    it 'does not show children order form' do
      expect(page).not_to have_content('Child menu order')
    end

    context 'setting the parent' do
      it 'sets the parent' do
        select(child2.name, from: 'Parent')
        click_button('Edit')
        expect(page).to have_content(child2.name)
        expect(page).not_to have_content(parent.name)
      end
    end
  end

end
