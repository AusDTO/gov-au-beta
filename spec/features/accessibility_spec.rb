require 'rails_helper'
require 'open-uri'

RSpec.describe 'accessibility:', :js, :truncate, :nodes_helper, type: :feature do

  Warden.test_mode!
  WebMock.allow_net_connect!

  shared_examples 'is accessible' do |url, as_code|
    it "#{url} is accessible" do
      if as_code
        url = eval(url)
      end
      visit url
      expect(page.status_code).to eq(200)
      # list of rules: https://github.com/dequelabs/axe-core/blob/master/doc/rule-descriptions.md
      # Bugfix for regions: https://github.com/AusDTO/gov-au-ui-kit/issues/313
      expect(page).to be_accessible.according_to(:wcag2a, :wcag2aa, 'best-practice')
    end
  end

  shared_examples 'is accessible sitemap' do |uri|
    sitemap = open(uri) { |f| Nokogiri::XML(f) }
    sitemap.css('url loc').each do |loc_block|
      url = loc_block.content
      if ENV.has_key?('ACCESSIBILITY_TEST_HOST')
        url = url.gsub('http://localhost:3000', ENV['ACCESSIBILITY_TEST_HOST'])
      end
      include_examples 'is accessible', url
    end
    sitemap.css('sitemap loc').each do |sitemap_block|
      url = sitemap_block.content
      if ENV.has_key?('ACCESSIBILITY_TEST_HOST')
        url = url.gsub('http://localhost:3000', ENV['ACCESSIBILITY_TEST_HOST'])
      end
      include_examples 'is accessible sitemap', url
    end
  end

  if ENV.has_key?('ACCESSIBILITY_TEST_URL')

    # Test accessibility of a given URL
    include_examples 'is accessible', ENV['ACCESSIBILITY_TEST_URL']

  elsif ENV.has_key?('ACCESSIBILITY_TEST_SITEMAP')

    # Test accessibility of all urls in a sitemap
    include_examples 'is accessible sitemap', ENV['ACCESSIBILITY_TEST_SITEMAP']

  else

    # Test accessibility of test data
    let!(:minister) { Fabricate(:minister) }
    let!(:minister_home) { Fabricate(:section_home, section: minister) }
    let!(:department) { Fabricate(:department, ministers: [minister]) }
    let!(:department_home) { Fabricate(:section_home, section: department) }
    let!(:topic) { Fabricate(:topic) }
    let!(:topic_home) { Fabricate(:section_home, section: topic) }
    let!(:news_article) { Fabricate(:news_article, parent: department_home, sections: [department, minister]) }
    let!(:general_content) { Fabricate(:general_content, parent: department_home) }
    let!(:placeholder_content) { Fabricate(:general_content, parent: department_home, placeholder: true) }

    include_examples 'is accessible', 'root_path', true
    include_examples 'is accessible', 'departments_path', true
    include_examples 'is accessible', 'ministers_path', true
    include_examples 'is accessible', 'new_feedback_path', true
    include_examples 'is accessible', 'news_articles_path', true
    include_examples 'is accessible', 'section_news_articles_path(department.slug)', true
    include_examples 'is accessible', 'public_node_path(news_article)', true
    include_examples 'is accessible', 'public_node_path(department.home_node)', true
    include_examples 'is accessible', 'public_node_path(minister.home_node)', true
    include_examples 'is accessible', 'public_node_path(topic.home_node)', true
    include_examples 'is accessible', 'public_node_path(general_content)', true

  end
end
