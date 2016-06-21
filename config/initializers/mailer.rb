Rails.application.configure do
  config.action_mailer.preview_path = "#{Rails.root}/spec/mailers/previews"

  unless Rails.env.test? or ENV['MAILTRAP_USERNAME'].blank? or ENV['MAILTRAP_PASSWORD'].blank?
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
        :user_name => ENV['MAILTRAP_USERNAME'],
        :password => ENV['MAILTRAP_PASSWORD'],
        :address => 'mailtrap.io',
        :domain => 'mailtrap.io',
        :port => '2525',
        :authentication => :cram_md5
    }
  end
end
