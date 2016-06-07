require 'rails_helper'

RSpec.describe 'creating content:', type: :feature do

  before :each do
    stub_request(:post, Rails.application.config.content_analysis_base_url + '/api/linters')
        .with(body: /Bad.*Content/)
        .to_return(:headers => {'Content-Type' => 'application/json'},
                   :body => '{"Bad Content" : "Good Content"}')
    stub_request(:post, Rails.application.config.content_analysis_base_url + '/api/linters')
        .with(body: /Good.*Content/)
        .to_return(:headers => {'Content-Type' => 'application/json'},
                   :body => '{}')
  end

  # need a section for pages to be a part of
  let!(:root) { Fabricate(:section) }
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
    let(:node_1) {Fabricate(:node)}
    let(:node_2) {Fabricate(:node)}
    it 'prefill the parent' do
      visit new_editorial_node_path(parent: node_1.id)
      expect(page).to have_select('Parent', selected: node_1.name)
      visit new_editorial_node_path(parent: node_2.id)
      expect(page).to have_select('Parent', selected: node_2.name)
    end
  end

end