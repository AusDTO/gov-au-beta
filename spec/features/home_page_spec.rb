require 'rails_helper'

RSpec.describe 'home page', type: :feature do

  Warden.test_mode!

  let!(:root_node) { Fabricate(:root_node) }
  let!(:real_category) { Fabricate(:category, placeholder: false, name: 'real category', summary: 'real summary')}
  let!(:placeholder_category) { Fabricate(:category, placeholder: true, name: 'placeholder category', summary: 'placeholder summary')}

  before do
    visit root_path
  end

  describe 'categories' do

    it 'test if real categories are working correctly' do
      within('.real-list') do
        expect(page).to have_link("real category", href: category_path(real_category.slug))
        expect(page).to have_css("p", text: "real summary")
      end
    end

    it 'test if placeholder categories are working correctly' do
      within('.placeholder-list') do
        expect(page).to have_css(".placeholder-link", text: "placeholder category")
        expect(page).to have_no_link("placeholder category")
        expect(page).to have_css("p", text: "placeholder summary")
      end
    end

  end
end
