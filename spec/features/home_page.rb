require 'rails_helper'
require 'axe/rspec'

RSpec.describe 'home page', type: :feature do

  Warden.test_mode!

  let!(:root_node) { Fabricate(:root_node) }

  before do
    visit root_path
  end

  describe 'categories' do
    subject { page }

    it {
      is_expected.to have_link('Infrastructure and telecommunications',
      href: '/categories/infrastructure-and-telecommunications')
    }

    it { is_expected.to be_accessible }
  end
end
