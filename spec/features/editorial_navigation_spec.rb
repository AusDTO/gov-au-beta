require 'rails_helper'

RSpec.describe 'editorial navigation:', type: :feature do

  Warden.test_mode!

  let!(:root_node) { Fabricate(:root_node) }
  let!(:section1) { Fabricate(:section) }
  let!(:section2) { Fabricate(:section) }
  let!(:node1) { Fabricate(:general_content, section: section1, parent: root_node) }
  let!(:node2) { Fabricate(:news_article, section: section2, parent: root_node) }

  context 'user' do
    let(:user) do
      u = Fabricate(:user)
      u.roles << Role.create!(:name => :author, :resource => section1)
      u.roles << Role.create!(:name => :reviewer, :resource => section2)
      u.save!
      u
    end

    before do
      login_as(user, scope: :user)
    end

    context 'the root path' do
      before do
        visit editorial_root_path
      end
      context "for a user with collaborator permissions" do
        it 'should have a list of sections' do
          expect(page.find_link(section1.name)[:href]).to eq(editorial_section_path(section1))
          expect(page.find_link(section2.name)[:href]).to eq(editorial_section_path(section2))
        end
      end
      context "for a user without collaborator permissions" do
        let(:user) { Fabricate(:user) }
        it 'can not see Create new page link' do
          expect(page).to have_no_link("Create new page")
        end
      end
    end

    context 'the nodes path' do
      context 'with a section_id' do
        it 'only displays nodes in that section' do
          visit editorial_section_nodes_path(section1)
          expect(page).to have_content(node1.name)
          expect(page).not_to have_content(node2.name)
          visit editorial_section_nodes_path(section2)
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
