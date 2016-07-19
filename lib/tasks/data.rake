namespace :data do
  desc 'Sets up News Section and home_node'

  task create_news: :environment do
    Section.find_or_create_by(name: 'news')
  end
end