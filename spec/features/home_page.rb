require 'rails_helper'

RSpec.describe 'home page', type: :feature do

  Warden.test_mode!

  let!(:root_node) { Fabricate(:root_node) }

  before do
    visit root_path
  end

  describe 'categories' do
    it { expect(page).to have_link('Infrastructure and telecommunications',
      href: '/categories/infrastructure-and-telecommunications') }
  end
end
