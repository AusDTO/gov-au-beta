$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'synergy/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'synergy'
  s.version     = Synergy::VERSION
  s.authors     = 'DTO'
  s.homepage    = 'https://dto.gov.au'
  s.summary     = 'Synergy.'
  s.description = 'Synergy.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '>= 5.0.0.rc1', '< 5.1'
end
