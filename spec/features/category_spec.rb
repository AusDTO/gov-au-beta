require 'rails_helper'

RSpec.describe 'category page', type: :feature do

  Warden.test_mode!

  let(:infrastructure_and_telecommunications) { Fabricate(:category, name: 'Infrastructure and telecommunications',
                                                          short_summary: 'Transport safety, television reception, telecommunications.',
                                                          summary: 'Australian Government information and services related to infrastructure and telecommunications.')}
  let(:subcategory) {infrastructure_and_telecommunications.children.find_or_create_by!(name:'Infrastructure')}
  let(:leaf_category) {subcategory.children.find_or_create_by!(name: 'Road')}
  let!(:topic) { Fabricate(:topic, name: 'Business', summary: 'The business section covers a range of business-related topics.',
                           categories: [leaf_category]) }
  let!(:topic_home) { Fabricate(:section_home, section: topic) }

  before do
    visit category_path(infrastructure_and_telecommunications)
  end

  describe 'displays category listing page' do
    it { expect(page).to have_content(infrastructure_and_telecommunications.name) }
    it { expect(page).to have_content(subcategory.name) }
    it { expect(page).to have_content(leaf_category.name) }
    it { expect(page).to have_content(topic.name) }
  end

end
