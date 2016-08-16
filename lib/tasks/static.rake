require 'spider'

namespace :static do
  desc 'Generate static site in ./out/ directory'
  task :generate => [
    'assets:clean',
    'assets:precompile',
    'static:start_rails'
  ] do
    Spider::Web.new("http://localhost:3001").run
    `rsync -ruv --exclude=.git/ public/ out/`

    # stop the server when we're done
    Rake::Task['static:stop_rails'].reenable
    Rake::Task['static:stop_rails'].invoke 

    Rake::Task['assets:clobber'].reenable
    Rake::Task['assets:clobber'].invoke 
  end

  desc 'Test capturing just one page with all referenced assets'
  task :home => [
    'assets:clean',
    'assets:precompile',
    'static:start_rails'
  ] do
    Spider::Web.new("http://localhost:3001", :max_depth => 1).run
    `rsync -ruv --exclude=.git/ public/ out/`

    # stop the server when we're done
    Rake::Task['static:stop_rails'].reenable
    Rake::Task['static:stop_rails'].invoke 

    Rake::Task['assets:clobber'].reenable
    Rake::Task['assets:clobber'].invoke 
  end

  desc 'Start a Rails server in the static Rails.env on port 3001'
  task :start_rails do
    ENV["RAILS_ENV"] = "static"
    `rails s -p 3001 -d`
  end

  desc 'Stop Rails'
  task :stop_rails do
    `cat tmp/pids/server.pid | xargs -I {} kill {}`
  end

  desc "Start a server using python's SimpleHTTPServer on port 8000 that will server our static site"
  task :serve, :directory do |t, args|
    Dir.chdir 'out' do
      `python -m SimpleHTTPServer 8000`
    end
  end
end
