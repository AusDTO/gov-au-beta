ruby '2.3.1'

# Primary source
source 'https://rubygems.org'

# Other sources
source 'https://rails-assets.org' do
  gem 'rails-assets-bootstrap-sass'
  gem 'rails-assets-editor.md'
  gem 'rails-assets-webfontloader'
end

# Core gems
gem 'rails', '>= 5.0.0.beta4', '< 5.1'
gem 'pg', '>= 0.19.0.beta'
gem 'puma', '~> 3.0'
gem 'uglifier', '>= 1.3.0'
gem 'sass-rails', '~> 5.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'turbolinks', '~> 5.x'
gem 'jbuilder', '~> 2.0'
gem 'bower-rails', '~> 0.10.0'
gem 'jquery-rails'
gem 'simple_form', github: 'kesha-antonov/simple_form', branch: 'rails-5-0'
gem 'reform'
gem 'reform-rails'
gem 'dry-types'
gem 'draper', git: 'https://github.com/coderdan/draper.git'
gem 'devise'
gem 'cf-app-utils' # cloudfoundry utils
gem 'rails_serve_static_assets' # http://docs.cloudfoundry.org/buildpacks/ruby/ruby-tips.html#rails-4
gem 'rails_12factor'
gem 'refile', require: ['refile/rails', 'refile/image_processing']
gem 'mini_magick'
gem 'friendly_id', github: 'norman/friendly_id', ref: '8531cdce'
gem 'acts_as_tree', '~> 2.4.0'
gem 'haml', '~> 4.0.7'
gem 'httparty',  '~> 0.13.0'
gem 'nokogiri', '1.6.8.rc3'
gem 'hashie'
gem 'odyssey'
gem 'rollbar'
gem 'oj', '~> 2.12.14'
gem 'enumerize', '~> 1.1.1'
gem 'cancancan'
gem 'rolify'
gem 'storext', github: 'micapam/storext', ref: '3e69a6b6' # force bundle to work (Rails 5)
gem 'markerb'
gem 'redcarpet'
gem 'andand'
gem 'diff-lcs', '~> 1.2.5'
gem 'gretel'
gem 'prometheus-client'
gem 'html2haml'

#TODO switch to thoughtbot's latest release once PRs are merged & released:
# - https://github.com/thoughtbot/administrate/pull/580 # sidebar config
# - https://github.com/thoughtbot/administrate/pull/575 # Rails 5
# - https://github.com/thoughtbot/administrate/pull/522/files # has_many field
gem 'administrate', github: 'micapam/administrate', ref: '34492932'
# Administrate depends on bourbon but doesn't include its own dependency yet
# https://github.com/thoughtbot/administrate/pull/614
gem 'bourbon'

group :development do
  gem 'web-console', '~> 3.0'
  gem 'byebug', platform: :mri
  gem 'listen'
end

group :test, :development do
  gem 'rspec-rails', '>= 3.5.0.beta4'
  gem 'rspec-collection_matchers', '~> 1.1', '>= 1.1.2'
  gem 'spinach', '~> 0.8.10'
  gem 'fabrication', '~> 2.15.0'
  gem 'faker', '~> 1.6.3'
  gem 'webmock', '~> 2.0.1'
  gem 'simplecov', '~> 0.11.2'
  gem 'capybara', '~> 2.7'
  gem 'dotenv-rails'
  gem 'pry-byebug'
end

group :test do
  gem 'shoulda-matchers', '~> 3.1'
  gem 'rails-controller-testing', '~> 0.1.1'
  gem 'database_cleaner', '~> 1.5.3'
  gem 'shoulda-kept-assign-to', '~> 1.1.0'
  gem 'launchy'
  gem 'codeclimate-test-reporter', require: nil
  gem 'with_model', '~> 1.2.1'
end

platforms :mingw, :mswin do
  gem 'tzinfo-data'
  gem 'wdm'
end
