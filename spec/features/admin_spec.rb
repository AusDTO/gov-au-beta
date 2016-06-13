require 'rails_helper'

RSpec.describe 'admin features', type: :feature do

  include Warden::Test::Helpers
  Warden.test_mode!
  let!(:admin_user) { Fabricate(:user, is_admin: true) }

  context 'an admin user' do
    let!(:agency) { Fabricate(:agency) }
    let!(:topic) { Fabricate(:topic) }
    let!(:news_article) { Fabricate(:news_article) }
    let!(:general_content) { Fabricate(:general_content) }

    before do
      login_as(admin_user, scope: :user)
      visit admin_root_path
    end

    after do
      logout(:user)
    end

    context 'home page sidebar links' do

      it 'should show links to administer section types' do
        expect(sidebar.find_link('Agencies')[:href]).to eq admin_agencies_path
        expect(sidebar.find_link('Topics')[:href]).to eq admin_topics_path
      end

      it 'should show links to administer content types' do
        expect(sidebar.find_link('General Contents')[:href]).to eq admin_general_contents_path
        expect(sidebar.find_link('News Articles')[:href]).to eq admin_news_articles_path
      end

      it 'should show links to administer users' do
      expect(sidebar.find_link('Users')[:href]).to eq admin_users_path
      end

      it 'should not show a link to administer sections en masse' do
        expect(sidebar).not_to have_link 'Sections'
      end

      it 'should not show links to nodes' do
        expect(sidebar).not_to have_link 'Nodes'
      end

      it 'should show agencies by default' do
        expect(page).to have_content agency.name
      end

      def sidebar
        find('.sidebar')
      end

    end

    context 'viewing a node' do
      it 'should show correct node type' do
        visit admin_news_article_path(news_article)
        expect(find('h1')).to have_content('News article')
        expect(find('h1')).not_to have_content('General content')
        visit admin_general_content_path(general_content)
        expect(find('h1')).to have_content('General content')
        expect(find('h1')).not_to have_content('News article')
      end
    end

    context 'editing a node' do
      it 'should show a list of states' do
        visit edit_admin_news_article_path(news_article)
        expect(page).to have_select('State', options: %w{draft published})
      end
    end

    context 'viewing a user' do
      it 'should show the email' do
        visit admin_user_path(admin_user)
        expect(find('h1')).to have_content(admin_user.email)
      end
    end
  end

  context 'a non-admin user' do
    let!(:non_admin_user) { Fabricate(:user, is_admin: false) }

    before do
      login_as(non_admin_user, scope: :user)
      visit admin_root_path
    end

    after do
      logout(:user)
    end

    it 'should have been redirected to root' do
      expect(page.current_path).to eq(root_path)
    end
  end

  context 'when logging in' do
    let!(:admin_user) { Fabricate(:user, is_admin: true) }
    let!(:non_admin_user) { Fabricate(:user, is_admin: false) }

    context 'as an admin user' do
      it 'redirect to admin interface' do
        visit admin_root_path
        fill_in('Email', with: admin_user.email)
        fill_in('Password', with: admin_user.password)
        click_button('Log in')
        expect(current_path).to eq(admin_root_path)
      end
    end

    context 'as a non-admin user' do
      it 'redirect to root path' do
        visit admin_root_path
        fill_in('Email', with: non_admin_user.email)
        fill_in('Password', with: non_admin_user.password)
        click_button('Log in')
        expect(current_path).to eq(root_path)
      end
    end
  end

end
