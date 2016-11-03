ruby '2.3.1'

# Primary source
source 'https://rubygems.org'

# Other sources
source 'https://rails-assets.org' do
  gem 'rails-assets-bootstrap-sass', '~> 3.3'
  gem 'rails-assets-webfontloader', '~> 1.6'
  gem 'rails-assets-showdown', '~> 1.4'
end

# Core gems
gem 'rails', '>= 5.0.0.beta4', '< 5.1'
gem 'activerecord-session_store', '~> 1.0'
gem 'pg', '>= 0.19.0.beta'
gem 'puma', '~> 3.0'
gem 'uglifier', '>= 1.3.0'
gem 'sass-rails', '~> 5.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jbuilder', '~> 2.0'
gem 'bower-rails', '~> 0.10.0'
gem 'jquery-rails', '~> 4.2'
gem 'simple_form', '~> 3.2', github: 'kesha-antonov/simple_form', branch: 'rails-5-0'
gem 'reform', '~> 2.2'
gem 'reform-rails', '~> 0.1'
gem 'dry-types', '~> 0.8'
gem 'draper', '~> 2.1', git: 'https://github.com/coderdan/draper.git'
gem 'devise', '~> 4.2'
gem 'cf-app-utils', '~> 0.6' # cloudfoundry utils
gem 'friendly_id', '~> 5.2.0.beta', github: 'norman/friendly_id', ref: '8531cdce'
gem 'acts_as_tree', '~> 2.4.0'
gem 'haml', '~> 4.0.7'
gem 'httparty',  '~> 0.13.0'
gem 'nokogiri', '1.6.8.rc3'
gem 'hashie', '~> 3.4'
gem 'odyssey', '~> 0.2'
gem 'rollbar', '~> 2.12'
gem 'oj', '~> 2.12.14'
gem 'enumerize', '~> 2.0.0'
gem 'cancancan', '~> 1.15'
gem 'rolify', '~> 5.1'
gem 'storext', '~> 2.0', github: 'micapam/storext', ref: '3e69a6b6' # force bundle to work (Rails 5)
gem 'markerb', '~> 1.1'
gem 'redcarpet', '~> 3.3'
gem 'andand', '~> 1.3'
gem 'diff-lcs', '~> 1.2.5'
gem 'gretel', '~> 3.0'
gem 'prometheus-client', '~> 0.6'
gem 'html2haml', '~> 2.0'
gem 'rubyzip', '>= 1.0.0'
gem 'ruby-sun-times', '~> 0.1', require: 'sun_times'
gem 'sitemap_generator', '~> 5.1'
gem 'newrelic_rpm', '~> 3.16.2'
gem 'two_factor_authentication',  github: 'Houdini/two_factor_authentication'
gem 'aws-sdk', '~> 2.5.0'
gem 'rufus-scheduler', '~> 3.2'
gem 'rqrcode', '~> 0.10'
gem 'valid_email', '~> 0.0'
gem 'paranoia', '~> 2.2.0.pre'
gem 'lograge', '~> 0.4'
gem 'request_store_rails', '~> 1.0'
gem 'liquid', '>= 4.0.0.rc2', '< 5'
gem 'paperclip', '~> 5.1.0'
gem 'kaminari', '~> 0.17'
gem 'kramdown', '~> 1.11'

#TODO switch to thoughtbot's latest release once PRs are merged & released:
# - https://github.com/thoughtbot/administrate/pull/580 # sidebar config
# - https://github.com/thoughtbot/administrate/pull/575 # Rails 5
# - https://github.com/thoughtbot/administrate/pull/522/files # has_many field
gem 'administrate', '~> 0.2', github: 'micapam/administrate', ref: '34492932'
# Administrate depends on bourbon but doesn't include its own dependency yet
# https://github.com/thoughtbot/administrate/pull/614
gem 'bourbon', '~> 4.2'

group :production do
  gem 'aws-ses', '~> 0.6.0', require: 'aws/ses'
end

group :development do
  gem 'web-console', '~> 3.0'
  gem 'byebug', '~> 9.0', platform: :mri
  gem 'listen', '~> 3.1'
  gem 'letter_opener', '~> 1.4'
end

group :test, :development do
  gem 'rspec-rails', '>= 3.5.0.beta4'
  gem 'rspec-collection_matchers', '~> 1.1', '>= 1.1.2'
  gem 'rspec-its', '~> 1.2'
  gem 'spinach', '~> 0.8.10'
  gem 'fabrication', '~> 2.15.0'
  gem 'faker', '~> 1.6.6'
  gem 'webmock', '~> 2.0.1'
  gem 'simplecov', '~> 0.11.2'
  gem 'capybara', '~> 2.7'
  gem 'dotenv-rails', '~> 2.1'
  gem 'pry-byebug', '~> 3.4'
end

group :test do
  gem 'shoulda-matchers', '~> 3.1'
  gem 'rails-controller-testing', '~> 0.1.1'
  gem 'database_cleaner', '~> 1.5.3'
  gem 'shoulda-kept-assign-to', '~> 1.1.0'
  gem 'launchy', '~> 2.4'
  gem 'codeclimate-test-reporter', '~> 0.6', require: nil
  gem 'with_model', '~> 1.2.1'
  gem 'axe-matchers', '~> 1.3'
  gem 'poltergeist', '~> 1.10'
  gem 'rspec_junit_formatter', '0.2.3'
end

platforms :mingw, :mswin do
  gem 'tzinfo-data'
  gem 'wdm'
end
