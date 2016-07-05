require 'rails_helper'

RSpec.describe 'admin features', type: :feature do

  Warden.test_mode!
  let!(:admin_user) { Fabricate(:user, is_admin: true) }
  let!(:root_node) { Fabricate(:root_node)}

  context 'an admin user' do
    let!(:agency) { Fabricate(:agency) }
    let!(:topic) { Fabricate(:topic) }
    let!(:news_article) { Fabricate(:news_article, parent: root_node) }
    let!(:general_content) { Fabricate(:general_content, parent: root_node) }

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
        # Can't use simple have_link matcher because it'll match 'Root Nodes'
        expect(sidebar.find_all('a', :text => /^Nodes$/)).to be_empty
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

    context 'adding a role' do
      it 'should create the role with the correct resource' do
        visit new_admin_role_path
        expect(current_path).to eq(new_admin_role_path)
        fill_in('Name', with: 'test')
        select(topic.name, from: 'Resource')
        click_button('Create')
        expect(page).to have_content(topic.name)
      end
    end

    context 'editing a role' do
      let (:role) { Fabricate(:role, resource: agency) }
      before do
        visit edit_admin_role_path(role)
      end

      it 'should prefill the resource' do
        expect(page).to have_select('Resource', selected: role.resource.name)
      end

      it 'should allow editing the resource' do
        select(topic.name, from: 'Resource')
        click_button('Update')
        expect(page).to have_content(topic.name)
        expect(page).not_to have_content(agency.name)
      end

      it 'should allow clearing the resource' do
        select('', from: 'Resource')
        click_button('Update')
        expect(page).not_to have_content(agency.name)
      end
    end

    context 'creating an agency' do
      it 'can create a govcms agency' do
        visit new_admin_agency_path
        expect(current_path).to eq(new_admin_agency_path)
        fill_in('Name', with: 'GovCMS agency')
        select('GovCMS', from: 'Cms type')
        click_button('Create')
        expect(page).to have_content('GovCMS agency')
      end

      it 'can create a Collaborate agency' do
        visit new_admin_agency_path
        expect(current_path).to eq(new_admin_agency_path)
        fill_in('Name', with: 'Collaborate agency')
        select('Collaborate', from: 'Cms type')
        click_button('Create')
        expect(page).to have_content('Collaborate agency')
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

    it 'should have been redirected to editorial' do
      expect(page.current_path).to eq(editorial_root_path)
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
      it 'redirect to editorial path' do
        visit admin_root_path
        fill_in('Email', with: non_admin_user.email)
        fill_in('Password', with: non_admin_user.password)
        click_button('Log in')
        expect(current_path).to eq(editorial_root_path)
      end
    end
  end

end
