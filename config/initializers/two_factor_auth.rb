
Rails.application.configure do
  config.use_2fa = !Rails.env.development? || ENV['FORCE_2FA'].present?
end
