require 'rails_helper'

RSpec.describe 'creating content:', type: :feature do
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

  let!(:root_node) { Fabricate(:root_node) }
  let(:section) { root_node; Fabricate(:section) }
  let(:author_user) { Fabricate(:user, author_of: section, reviewer_of: section) }
  let(:name) {'test name'}
  let(:slug) {'test-name'}

  context 'when creating general content' do
    before do
      visit new_editorial_section_node_path(section, type: :general_content)
    end

    it 'show the correct form' do
      expect(page).to have_content(/general content/i)
    end

    context 'with valid data' do
      it 'create the correct type of content' do
        fill_in('Name', with: name)
        fill_in('Body', with: 'Good Content')
        click_button('Create')
        expect(page).to have_content(name)
        expect(page).to have_content(/Good Content/i)
      end
    end

    context 'can set table of contents' do
      def set_toc(value)
        fill_in('Name', with: name)
        fill_in('Body', with: "## heading 1\nGood Content\n### heading 2\n## heading 3")
        select(I18n.t("options.toc.x#{value}"), from: 'Table of contents')
        click_button('Create')
        click_button('Publish')
      end

      it 'to zero' do
        set_toc(0)
        expect(page).not_to have_css('nav.index-links')
      end

      it 'to one' do
        set_toc(1)
        expect(page).to have_css('nav.index-links')
        within 'nav.index-links' do
          expect(page).to have_link('heading 1')
          expect(page).not_to have_link('heading 2')
          expect(page).to have_link('heading 3')
        end
      end

      it 'to two' do
        set_toc(2)
        expect(page).to have_css('nav.index-links')
        within 'nav.index-links' do
          expect(page).to have_content('heading 1')
          expect(page).to have_content('heading 2')
          expect(page).to have_content('heading 3')
        end
      end
    end

    # FIXME: restore this spec once CAS validation is restored
    # context 'with invalid data' do
    #   it 'return to the edit form' do
    #     fill_in('Name', with: name)
    #     fill_in('Body', with: 'Bad Content')
    #     click_button('Create')
    #     expect(page).to have_content(/failed.*content.*analysis/i)
    #   end
    # end

    it_behaves_like 'robust to XSS'
  end

  context 'when creating a news article' do
    before do
      visit new_editorial_section_node_path(section, type: :news_article)
    end

    it 'show the correct form' do
      expect(page).to have_content(/news article/i)
    end

    context 'with valid data' do
      it 'create the correct type of content' do
        fill_in('Name', with: name)
        fill_in('Body', with: 'Good Content')
        select('2017', from: 'Release date')
        click_button('Create')
        expect(page).to have_content(/Good Content/i)
      end
    end

    it_behaves_like 'robust to XSS'
  end

  context 'when no type is specified' do
    it 'default to general content' do
      visit new_editorial_section_node_path(section)
      expect(page).to have_content(/general content/i)
    end
  end

  context 'with a parent specified' do
    let(:node_1) {Fabricate(:node, section: section)}
    let(:node_2) {Fabricate(:node, section: section)}

    it 'prefill the parent' do
      visit new_editorial_section_node_path(section, parent_id: node_1.id)
      expect(page).to have_select('Parent', selected: node_1.name)
      visit new_editorial_section_node_path(section, parent_id: node_2.id)
      expect(page).to have_select('Parent', selected: node_2.name)
    end
  end

  describe 'create a child of an existing page' do
    let(:node) { Fabricate(:node, section: section) }

    it 'should allow a user to create a child of a specific type' do
      visit nodes_path path: node.path
      click_link 'New page'
      expect(page).to have_content 'Create a new page'
      select 'News article', from: 'Page type'
      click_button 'New page'
      expect(page).to have_content 'Release date'
    end

    it 'should prefill the section and parent' do
      visit nodes_path path: node.path
      click_link 'New page'
      expect(page).to have_content 'Create a new page'
      click_button 'New page'
      expect(page).to have_select('Parent', selected: node.name)
    end
  end

  describe 'new page for a section' do
    it 'should allow you to create a new page' do
      visit "/editorial/#{section.id}/nodes/prepare"
      select 'General content', from: 'Page type'
      click_button 'New page'
      fill_in 'Name', with: 'foo'
      fill_in 'Body', with: 'Random content'
      click_button 'Create page'    
      expect(page).to have_content 'Random content'
    end
  end

end
