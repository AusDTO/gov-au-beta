require 'rails_helper'

RSpec.describe 'accordion group', :js, :truncate, type: :feature do

  Warden.test_mode!
  WebMock.allow_net_connect!


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

  it 'test if accordion group buttons are working' do

    # test if 'expand all' and 'collapse all' buttons are present
    expect(page).to have_css(".accordion-group .open-all-accordions")
    expect(page).to have_css(".accordion-group .close-all-accordions")

    # test if 'expand all' button opens accordions and disables 'expand all' button
    click_button 'Expand all'
    expect(find('.accordion-group details')['aria-expanded']).to eq('true')
    expect(page).to have_css(".accordion-group.disable-open-button")

    # test if 'collapse all' button closes accordions and disable 'collapse all button'
    click_button 'Collapse all'
    expect(find('.accordion-group details')['aria-expanded']).to eq('false')
    expect(page).to have_css(".accordion-group.disable-close-button")

  end
end
