RSpec.shared_context 'shared_two_factor_login', :shared_context => :metadata do
  def complete_2fa_login(user, totp=false)
    # Need to navigate somewhere before redirect to 2FA login completion
    visit root_path
    code = user.direct_otp

    if totp
      # Secret key defined in fabricators/user.rb
      code = ROTP::TOTP.new('averysecretkey').now
    end

    fill_in('Enter 6 digit code', with: code)
    click_button('Verify')
  end
end