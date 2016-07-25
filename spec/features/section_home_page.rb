require 'rails_helper'

RSpec.describe 'home page', type: :feature do

  Warden.test_mode!

  let!(:section) { Fabricate(:section) }
  let!(:published) { Fabricate(:news_article, section: section, state: 'published') }
  let!(:draft) { Fabricate(:news_article, section: section, state: 'draft') }

  before do
    visit nodes_path(path: section.home_node.path)
  end

  describe 'displays news on home page' do
    it { expect(page).to have_content(published.name) }
    it { expect(page).to_not have_content(draft.name) }
  end

end
