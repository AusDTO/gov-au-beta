require 'rails_helper'

RSpec.describe 'admin features', type: :feature do

  include Warden::Test::Helpers
  Warden.test_mode!

  describe 'home page sidebar links' do
    let!(:agency) { Fabricate(:agency) }
    let!(:topic) { Fabricate(:topic) }

    context 'an admin user' do
      let!(:admin_user) { Fabricate(:user, is_admin: true) }

      before do 
        login_as(admin_user, scope: :user)
        visit '/admin'
      end

      after do
        logout(:user)
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
    end

    context 'a non-admin user' do
      let!(:non_admin_user) { Fabricate(:user, is_admin: false) }

      before do 
        login_as(non_admin_user, scope: :user)
        visit '/admin'
      end

      after do
        logout(:user)
      end
      
      it 'should have been redirected to root' do
        expect(page.current_path).to eq('/')
      end
    end

    def sidebar
      find('.sidebar')
    end

  end
end
