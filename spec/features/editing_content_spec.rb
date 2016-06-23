require 'rails_helper'

RSpec.describe 'editing content', type: :feature do

  include Warden::Test::Helpers
  Warden.test_mode!
  let!(:section) { Fabricate(:section) }
  let!(:author) { Fabricate(:user, author_of: section) }

  before :each do
    stub_request(:post, Rails.application.config.content_analysis_base_url + '/api/linters')
        .with(body: /Bad.*Content/)
        .to_return(:headers => {'Content-Type' => 'application/json'},
                   :body => '{"Bad Content" : "Good Content"}')
    stub_request(:post, Rails.application.config.content_analysis_base_url + '/api/linters')
        .with(body: /(Good|Random).*Content/i)
        .to_return(:headers => {'Content-Type' => 'application/json'},
                   :body => '{}')
    login_as(author, scope: :user)
  end

  after do
    logout(:user)
  end

  context 'on a node page' do
    let!(:node) { Fabricate(:node, section: section) }

    it 'should show a link to edit the content in the CMS' do
      visit "/#{node.section.slug}/#{node.slug}"
      expect(page).to have_link('Edit')
    end
  end

  context 'on a section page' do
    it 'should not show an edit link' do
      visit "/#{section.slug}"
      expect(page).not_to have_link('Edit this page')
    end
  end

  context 'when editing content' do
    let!(:section1) { Fabricate(:section) }
    let!(:section2) { Fabricate(:section) }
    let!(:node1) { Fabricate(:general_content, section: section1, state: 'draft') }
    let!(:node2) { Fabricate(:news_article, section: section2, state: 'draft') }

    before :each do
      author.add_role(:author, section1)
      author.add_role(:author, section2)
    end

    it 'should prefill the form' do
      [node1, node2].each do |node|
        visit edit_editorial_node_path(id: node.id)
        expect(current_path).to eq edit_editorial_node_path(id: node.id)
        expect(page).to have_select('Section', selected: node.section.name)
        expect(find_field('Name').value).to eq(node.name)
      end
    end

    context 'editing the name' do
      it 'should update the record' do
        [node1, node2].each do |node|
          new_name = "#{node.name} updated"
          visit edit_editorial_node_path(id: node.id)
          fill_in('Name', with: new_name)
          click_button('Update')
          expect(page).to have_content(new_name)
        end
      end
    end

    context 'with bad content' do
      it 'should return to the edit form' do
        visit edit_editorial_node_path(id: node1.id)
        fill_in('Body', with: 'Bad Content')
        click_button('Update')
        expect(page).to have_content(/edit/i)
        expect(page).to have_content(/failed.*content.*analysis/i)
      end
    end
  end

end
