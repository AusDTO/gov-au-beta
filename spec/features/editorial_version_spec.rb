require 'rails_helper'

RSpec.describe 'editorial version details', type: :feature do
  Warden.test_mode!

  let!(:section) { Fabricate(:section) }
  let!(:section_home) { Fabricate(:section_home, section: section) }
  let!(:author) { Fabricate(:user, author_of: section) }

  describe 'editorial#index' do
    before do
      login_as author
      visit editorial_root_path
    end

    it 'displays version tag and sha' do
      # Values set in test.rb
      expect(page).to have_content('v1.0.0')
      expect(page).to have_content('abcdefghijkl'[0..6])
    end
  end
end