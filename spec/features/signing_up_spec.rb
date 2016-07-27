require 'rails_helper'

RSpec.describe 'signing up', type: :feature do

  Warden.test_mode!

  let!(:root_node) { Fabricate(:root_node) }

  it 'sets the name' do
    visit new_user_registration_path
    fill_in('Email', with: 'test@example.com')
    fill_in('First name', with: 'first')
    fill_in('Last name', with: 'last')
    # Can't use fill_in for Password because it's an ambiguous match
    find('#user_password').set('password')
    fill_in('Password confirmation', with: 'password')
    click_button('Sign up')
    expect(page).to have_content('first last')
  end
end
