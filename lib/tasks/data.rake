namespace :data do
  desc 'Sets up News Section and home_node'

  task create_news: :environment do
    unless Section.find_by(name: 'news').present?
      Section.create!(name: 'news')
    end
  end
end