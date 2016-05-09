ruby '2.3.0'

# Primary source
source 'https://rubygems.org'

# Other sources
source 'https://rails-assets.org' do
  gem 'rails-assets-bootstrap-sass'
end

# Core gems
gem 'rails', '>= 5.0.0.beta4', '< 5.1'
gem 'pg'
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
gem 'draper', git: 'https://github.com/coderdan/draper.git'
gem 'devise'
gem 'cf-app-utils' # cloudfoundry utils 
gem 'rails_serve_static_assets' # http://docs.cloudfoundry.org/buildpacks/ruby/ruby-tips.html#rails-4
gem 'rails_12factor'
gem 'refile', require: ['refile/rails', 'refile/image_processing']
gem 'mini_magick'
gem 'friendly_id', '~> 5.1.0'
gem 'acts_as_tree', '~> 2.4.0'
gem 'haml', '~> 4.0.7'
gem 'httparty',  '~> 0.13.0'

group :development do 
  gem 'web-console', '~> 3.0'
  gem 'byebug', platform: :mri
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test, :development do 
  gem 'rspec-rails', '>= 3.5.0.beta3'
  gem 'spinach', '~> 0.8.10'
  gem 'fabrication', '~> 2.15.0'
  gem 'faker', '~> 1.6.3'
  gem 'webmock', '~> 2.0.1'
  gem 'simplecov', '~> 0.11.2'
end

group :test do 
  gem 'shoulda-matchers', '~> 3.1'
end
