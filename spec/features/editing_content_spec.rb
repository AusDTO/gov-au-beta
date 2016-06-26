require 'rails_helper'

RSpec.describe 'editing content', type: :feature do

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
        visit nodes_path section: node.section.slug, path: node.path
        click_link 'Edit'
        expect(current_path).to eq new_editorial_node_submission_path node
        expect(find_field('Body').value).to eq node.content_body
      end
    end

    context 'creating a submission' do
      before do
        visit new_editorial_node_submission_path node1
        fill_in 'Body', with: 'Brand new content'
        click_button 'Submit for review'
      end

      it 'should take the user to the created submission view' do
        expect(current_path).to match /editorial\/submissions\/\d+/
      end

      it 'should not update the record directly' do
        visit nodes_path section: node1.section.slug, path: node1.path
        expect(page).not_to have_content 'Brand new content'
      end
    end

    context 'with bad content' do
      it 'should return to the edit form' do
        visit edit_editorial_node_path(id: node1.id)
        fill_in('Body', with: 'Bad Content')
        click_button('Submit for review')
        expect(page).to have_content(/Your changes have been submitted/i)
      end
    end

    it_behaves_like 'robust to XSS' do
      before { visit edit_editorial_node_path(id: node1.id) }
    end
    it_behaves_like 'robust to XSS' do
      before { visit edit_editorial_node_path(id: node2.id) }
    end
  end

end
