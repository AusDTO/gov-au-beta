require 'rails_helper'

RSpec.describe 'cannot enumerate emails', type: :feature do

  Warden.test_mode!

  let!(:root_node) { Fabricate(:root_node) }
  let(:fake_email) { 'not-a-real-email@gov.au' }
  let!(:user) { Fabricate(:user) }

  it 'on password reset form' do
    visit new_user_password_path
    fill_in('Email', with: user.email)
    click_button('Send')
    expect(current_path).to eq(new_user_session_path)
    flash1 = page.find('.callout').text
    visit new_user_password_path
    fill_in('Email', with: fake_email)
    click_button('Send')
    expect(current_path).to eq(new_user_session_path)
    flash2 = page.find('.callout').text
    expect(flash1).to eq(flash2)
  end

  it 'on email confirmation form' do
    visit user_confirmation_path
    fill_in('Email', with: user.email)
    click_button('Resend')
    expect(current_path).to eq(new_user_session_path)
    flash1 = page.find('.callout').text
    visit user_confirmation_path
    fill_in('Email', with: fake_email)
    click_button('Resend')
    expect(current_path).to eq(new_user_session_path)
    flash2 = page.find('.callout').text
    expect(flash1).to eq(flash2)
  end

  it 'on sign in form' do
    visit new_user_session_path
    fill_in('Email', with: user.email)
    fill_in('Password', with: 'foo')
    click_button('Sign in')
    flash1 = page.find('.callout').text
    fill_in('Email', with: fake_email)
    fill_in('Password', with: 'foo')
    click_button('Sign in')
    flash2 = page.find('.callout').text
    expect(flash1).to eq(flash2)
  end
end
