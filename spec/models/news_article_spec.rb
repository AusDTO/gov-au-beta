require 'rails_helper'

RSpec.describe NewsArticle, type: :model do
  it { expect(described_class).to be < Node }
  it { is_expected.to respond_to :release_date }

  describe '#published_for_section' do
    let!(:section) { Fabricate(:section) }
    let!(:other_section) { Fabricate(:section) }
    let!(:published) { Fabricate(:news_article, section: section, state: 'published') }
    let!(:other_published) { Fabricate(:news_article, section: other_section, state: 'published') }
    let!(:draft) { Fabricate(:news_article, section: section, state: 'draft') }

    it 'should return published news' do
      result = NewsArticle.published_for_section(section).all

      expect(result).to include(published)

      expect(result).to_not include(draft)
      expect(result).to_not include(other_published)
    end


  end
end
