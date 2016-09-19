
if Rails.env.production?
  ActionMailer::Base.add_delivery_method(:ses, AWS::SES::Base,
    access_key_id:      ENV['AWS_SES_ACCESS_KEY_ID'],
    secret_access_key:  ENV['AWS_SES_SECRET_ACCESS_KEY'],
    server: "email.us-west-2.amazonaws.com"
  )
end
