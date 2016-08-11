require 'rails_helper'

RSpec.describe 'section news index', type: :feature do
  Warden.test_mode!

  let!(:section_a) { Fabricate(:section) }
  let!(:section_home_a) { Fabricate(:section_home, section: section_a) }
  let!(:section_b) { Fabricate(:section) }
  let!(:section_home_b) { Fabricate(:section_home, section: section_b) }
  let!(:article_a) { Fabricate(:news_article, parent: section_home_a, sections: [section_b], state: 'published') }
  let!(:article_b) { Fabricate(:news_article, parent: section_home_b, sections: [section_a], state: 'published') }

  before { visit section_news_articles_path(section_a.slug) }

  describe 'news#index' do
    context 'for a section' do
      it 'displays published and distributed articles' do
        expect(page).to have_content(article_a.name)
        expect(page).to have_content(article_b.name)
      end
    end
  end
end
