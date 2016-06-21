require 'rails_helper'

RSpec.describe 'creating content:', type: :feature do
  include Warden::Test::Helpers
  Warden.test_mode!

  before :each do
    stub_request(:post, Rails.application.config.content_analysis_base_url + '/api/linters')
        .with(body: /Bad.*Content/i)
        .to_return(:headers => {'Content-Type' => 'application/json'},
                   :body => '{"Bad Content" : "Good Content"}')
    stub_request(:post, Rails.application.config.content_analysis_base_url + '/api/linters')
        .with(body: /(Good|Random).*Content/i)
        .to_return(:headers => {'Content-Type' => 'application/json'},
                   :body => '{}')
    login_as(author_user, scope: :user)
  end

  # need a section for pages to be a part of
  let!(:root) { Fabricate(:section) }
  let!(:author_user) { Fabricate(:user, author_of: root) }
  let(:name) {'test name'}
  let(:slug) {'test-name'}

  context 'when creating general content' do
    it 'show the correct form' do
      visit new_editorial_node_path(type: :general_content)
      expect(page).to have_content(/general content/i)
    end

    context 'with valid data' do
      it 'create the correct type of content' do
        visit new_editorial_node_path(type: :general_content)
        fill_in('Name', with: name)
        fill_in('Body', with: 'Good Content')
        click_button('Create')
        expect(current_path).to match(Regexp.new(editorial_nodes_path + '/\d+'))
        expect(page).not_to have_content(/release date/i)
      end
    end

    context 'with invalid data' do
      it 'return to the edit form' do
        visit new_editorial_node_path(type: :general_content)
        fill_in('Name', with: name)
        fill_in('Body', with: 'Bad Content')
        click_button('Create')
        expect(page).to have_content(/failed.*content.*analysis/i)
      end
    end
  end

  context 'when creating a news article' do
    it 'show the correct form' do
      visit new_editorial_node_path(type: :news_article)
      expect(page).to have_content(/news article/i)
    end

    context 'with valid data' do
      it 'create the correct type of content' do
        visit new_editorial_node_path(type: :news_article)
        fill_in('Name', with: name)
        fill_in('Body', with: 'Good Content')
        select('2017', from: 'Release date')
        click_button('Create')
        expect(current_path).to match(Regexp.new(editorial_nodes_path + '/\d+'))
        expect(page).to have_content(/release date/i)
      end
    end
  end

  context 'when no type is specified' do
    it 'default to general content' do
      visit new_editorial_node_path
      expect(page).to have_content(/general content/i)
    end
  end

  context 'with a section specified' do
    let(:section_1) {Fabricate(:section)}
    let(:section_2) {Fabricate(:section)}
    it 'prefill the section' do
      visit new_editorial_node_path(section: section_1.id)
      expect(page).to have_select('Section', selected: section_1.name)
      visit new_editorial_node_path(section: section_2.id)
      expect(page).to have_select('Section', selected: section_2.name)
    end
  end

  context 'with a parent specified' do
    let(:node_1) {Fabricate(:node, section: root)}
    let(:node_2) {Fabricate(:node, section: root)}

    it 'prefill the parent' do
      visit new_editorial_node_path(parent: node_1.id)
      expect(page).to have_select('Parent', selected: node_1.name)
      visit new_editorial_node_path(parent: node_2.id)
      expect(page).to have_select('Parent', selected: node_2.name)
    end
  end

  describe 'create a child of an existing page' do
    let!(:node) { Fabricate(:node, section: root) }

    it 'should allow a user to create a child of a specific type' do

      visit "/#{node.section.slug}/#{node.slug}"
      click_link 'New page here'
      expect(page).to have_content 'Create a new page'
      select 'News article', from: 'Page type'
      click_button 'New page'
      expect(page).to have_content 'Release date'
    end

    it 'should prefill the section and parent' do
      visit "/#{node.section.slug}/#{node.slug}"
      click_link 'New page here'
      expect(page).to have_content 'Create a new page'
      click_button 'New page'
      expect(page).to have_select('Section', selected: node.section.name)
      expect(page).to have_select('Parent', selected: node.name)
    end
  end

  describe 'create a top node in a section' do
    it 'should prefill the section' do
      visit "/#{root.slug}"
      click_link 'New page here'
      expect(page).to have_content 'Create a new page'
      expect(page).to have_content root.name
      click_button 'New page'
      expect(page).to have_select('Section', selected: root.name)
    end
  end

end