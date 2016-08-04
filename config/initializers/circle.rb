Rails.application.configure do
  # Configure tag and sha1 variables
  config.version_tag = ENV['CIRCLE_TAG']
  config.version_sha = ENV['CIRCLE_SHA1']
end