require 'rails_helper'

RSpec.describe 'editorial navigation:', type: :feature do

  Warden.test_mode!

  let!(:section1) { Fabricate(:section) }
  let!(:section2) { Fabricate(:section) }
  let!(:node1) { Fabricate(:general_content, section: section1) }
  let!(:node2) { Fabricate(:news_article, section: section2) }

  context 'user' do
    let!(:user) { Fabricate(:user) }

    before do
      login_as(user, scope: :user)
    end

    context 'the root path' do
      before do
        visit editorial_root_path
      end
      it 'should have a list of sections' do
        expect(page.find_link(section1.name)[:href]).to eq(editorial_section_path(section: section1.slug))
        expect(page.find_link(section2.name)[:href]).to eq(editorial_section_path(section: section2.slug))
      end
      it 'can not see Create new page link' do
        expect(page).to have_no_link("Create new page")
      end
    end

    context 'the nodes path' do
      context 'without a section_id' do
        it 'redirects to section list' do
          visit editorial_nodes_path
          expect(current_path).to eq(editorial_root_path)
        end
      end

      context 'with a section_id' do
        it 'only displays nodes in that section' do
          visit editorial_nodes_path(section_id: section1.id)
          expect(page).to have_content(node1.name)
          expect(page).not_to have_content(node2.name)
          visit editorial_nodes_path(section_id: section2.id)
          expect(page).to have_content(node2.name)
          expect(page).not_to have_content(node1.name)
        end
      end
    end
  end

  context 'author user' do
    let!(:author_user) { Fabricate(:user, author_of: section1) }
    before do
      login_as(author_user, scope: :user)
      visit editorial_root_path
    end

    it 'can see Create new page link' do
      expect(page).to have_link("Create new page")
    end
  end
end
