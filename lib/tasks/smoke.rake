# A selection of tests to smoke-test a site
namespace :smoke do
  begin
    require 'rspec/core/rake_task'
    desc 'Run accessibility tests against an external site'
    RSpec::Core::RakeTask.new(:accessibility) do |t|
      unless ENV.has_key?('ACCESSIBILITY_TEST_URL') or ENV.has_key?('ACCESSIBILITY_TEST_SITEMAP')
        raise 'Please define either ACCESSIBILITY_TEST_URL or ACCESSIBILITY_TEST_SITEMAP'
      end
      t.pattern = 'spec/features/accessibility_spec.rb'
    end
  rescue LoadError
  end
end