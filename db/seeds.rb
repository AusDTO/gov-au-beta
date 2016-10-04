# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'synergy/cms_import'

password = ENV['SEED_USER_PASSWORD']
raise 'SEED_USER_PASSWORD cannot be empty' if password.blank?

unless admin = User.find_by(email: 'admin@example.gov.au')
  admin = User.create!(email: 'admin@example.gov.au',
                       password: password,
                       confirmed_at: DateTime.now)
end

unless author = User.find_by(email: 'author@example.gov.au')
  author = User.create!(email: 'author@example.gov.au',
                        password: password,
                        confirmed_at: DateTime.now)
end

unless reviewer = User.find_by(email: 'reviewer@example.gov.au')
  reviewer = User.create!(email: 'reviewer@example.gov.au',
                          password: password,
                          confirmed_at: DateTime.now)
end

unless owner = User.find_by(email: 'owner@example.gov.au')
  owner = User.create!(email: 'owner@example.gov.au',
                       password: password,
                       confirmed_at: DateTime.now)
end

admin.add_role :admin

names = {
    admin: [admin, %w(Joe Admin)],
    author: [author, %w(Jane Author)],
    reviewer: [reviewer, %w(John Reviewer)],
    owner: [owner, %w(Sarah Owner)]
}

names.keys.each do |key|
  names[key][0].first_name = names[key][1][0]
  names[key][0].last_name = names[key][1][1]
  names[key][0].save!
end

if ENV['QAFIRE']
  Topic.all.each do |topic|
    author.add_role :author, topic
    reviewer.add_role :reviewer, topic
    owner.add_role :owner, topic
  end
else
  RootNode.find_or_create_by!(state: 'published')

  category = Category.find_or_create_by!(name: 'Infrastructure and telecommunications',
                                         short_summary: 'Transport safety, television reception, telecommunications.',
                                         summary: 'Australian Government information and services related to infrastructure and telecommunications.')
  category.save
  subcategory = category.children.find_or_create_by!(name: 'Infrastructure')
  leaf_category = subcategory.children.find_or_create_by!(name: 'Road')

  topic = Topic.find_or_create_by!(name: 'Business')
  topic.summary = 'The business section covers a range of business-related topics.'
  topic.categories << leaf_category
  topic.save!

  author.add_role :author, topic
  reviewer.add_role :reviewer, topic
  owner.add_role :owner, topic

  news1 = NewsArticle.with_name(
      'Business News'
  ).find_or_create_by!(
      {
          section: topic,
          state: :published,
      }
  ) do |news_article|
    news_article.name = 'Business News'
    news_article.release_date = Date.today
  end
  news1.update(release_date: Date.today) if news1.release_date.blank?
  news1.revise!(content_body: 'foobar').apply!

  def make_node(parent, name, klass = GeneralContent)
    # Note: you cannot find_by with :name because it's in the content jsonb field
    klass.with_name(name)
        .find_or_create_by!(
            {
                state: :published,
                parent: parent
            }
        ) do |node|
      node.name = name
    end
  end

  node1 = make_node(topic.home_node, 'Starting a Business')
  node2 = make_node(node1, 'Finding Staff')
  node2.revise!(content_body: 'lorem ipsum').apply!
  node3 = make_node(node2, 'Types of Employment')

  times = Topic.find_or_create_by!(name: 'Times and dates') do |topic|
    topic.summary = 'Australian times and dates'
  end

  public_hols = make_node(times.home_node, 'Australian public holidays', CustomTemplateNode)
  public_hols.update(template: 'custom/public_holidays_tas')
  public_hols_tas = make_node(public_hols, 'Tasmania', CustomTemplateNode)
  public_hols_tas.update(template: 'custom/public_holidays_tas', options: {suppress_in_nav: true})
  public_hols_qld = make_node(public_hols, 'Queensland', CustomTemplateNode)
  public_hols_qld.update(template: 'custom/public_holidays_qld', options: {suppress_in_nav: true})
  public_hols_nsw = make_node(public_hols, 'New South Wales', CustomTemplateNode)
  public_hols_nsw.update(template: 'custom/public_holidays_nsw', options: {suppress_in_nav: true})
  public_hols_act = make_node(public_hols, 'Australian Capital Territory', CustomTemplateNode)
  public_hols_act.update(template: 'custom/public_holidays_act', options: {suppress_in_nav: true})
  public_hols_vic = make_node(public_hols, 'Victoria', CustomTemplateNode)
  public_hols_vic.update(template: 'custom/public_holidays_vic', options: {suppress_in_nav: true})
  public_hols_nt = make_node(public_hols, 'Northern Territory', CustomTemplateNode)
  public_hols_nt.update(template: 'custom/public_holidays_nt', options: {suppress_in_nav: true})
  public_hols_sa = make_node(public_hols, 'South Australia', CustomTemplateNode)
  public_hols_sa.update(template: 'custom/public_holidays_sa', options: {suppress_in_nav: true})
  public_hols_wa = make_node(public_hols, 'Western Australia', CustomTemplateNode)
  public_hols_wa.update(template: 'custom/public_holidays_wa', options: {suppress_in_nav: true})
  daylight_saving = make_node(times.home_node, 'Australian daylight saving', CustomTemplateNode)
  daylight_saving.update(template: 'custom/daylight_savings_tas')
  daylight_saving_tas = make_node(daylight_saving, 'Tasmania', CustomTemplateNode)
  daylight_saving_tas.update(template: 'custom/daylight_savings_tas', options: {suppress_in_nav: true})
  daylight_saving_qld = make_node(daylight_saving, 'Queensland', CustomTemplateNode)
  daylight_saving_qld.update(template: 'custom/daylight_savings_qld', options: {suppress_in_nav: true})
  daylight_saving_vic = make_node(daylight_saving, 'Victoria', CustomTemplateNode)
  daylight_saving_vic.update(template: 'custom/daylight_savings_vic', options: {suppress_in_nav: true})
  daylight_saving_act = make_node(daylight_saving, 'Australian Capital Territory', CustomTemplateNode)
  daylight_saving_act.update(template: 'custom/daylight_savings_act', options: {suppress_in_nav: true})
  daylight_saving_nsw = make_node(daylight_saving, 'New South Wales', CustomTemplateNode)
  daylight_saving_nsw.update(template: 'custom/daylight_savings_nsw', options: {suppress_in_nav: true})
  daylight_saving_wa = make_node(daylight_saving, 'Western Australia', CustomTemplateNode)
  daylight_saving_wa.update(template: 'custom/daylight_savings_wa', options: {suppress_in_nav: true})
  daylight_saving_sa = make_node(daylight_saving, 'South Australia', CustomTemplateNode)
  daylight_saving_sa.update(template: 'custom/daylight_savings_sa', options: {suppress_in_nav: true})
  daylight_saving_nt = make_node(daylight_saving, 'Northern Territory', CustomTemplateNode)
  daylight_saving_nt.update(template: 'custom/daylight_savings_nt', options: {suppress_in_nav: true})
  school_hols = make_node(times.home_node, 'School holidays and term dates', CustomTemplateNode)
  school_hols.update(template: 'custom/school_holidays_tas')
  school_hols_tas = make_node(school_hols, 'Tasmania', CustomTemplateNode)
  school_hols_tas.update(template: 'custom/school_holidays_tas', options: {suppress_in_nav: true})
  school_hols_qld = make_node(school_hols, 'Queensland', CustomTemplateNode)
  school_hols_qld.update(template: 'custom/school_holidays_qld', options: {suppress_in_nav: true})
  school_hols_nsw = make_node(school_hols, 'New South Wales', CustomTemplateNode)
  school_hols_nsw.update(template: 'custom/school_holidays_nsw', options: {suppress_in_nav: true})
  school_hols_act = make_node(school_hols, 'Australian Capital Territory', CustomTemplateNode)
  school_hols_act.update(template: 'custom/school_holidays_act', options: {suppress_in_nav: true})
  school_hols_vic = make_node(school_hols, 'Victoria', CustomTemplateNode)
  school_hols_vic.update(template: 'custom/school_holidays_vic', options: {suppress_in_nav: true})
  school_hols_nt = make_node(school_hols, 'Northern Territory', CustomTemplateNode)
  school_hols_nt.update(template: 'custom/school_holidays_nt', options: {suppress_in_nav: true})
  school_hols_sa = make_node(school_hols, 'South Australia', CustomTemplateNode)
  school_hols_sa.update(template: 'custom/school_holidays_sa', options: {suppress_in_nav: true})
  school_hols_wa = make_node(school_hols, 'Western Australia', CustomTemplateNode)
  school_hols_wa.update(template: 'custom/school_holidays_wa', options: {suppress_in_nav: true})

  node3.content_body = 'This is draft content I would like submitted'

  if node3.submissions.blank?
    sub = Submission.new(revision: node3.revise!(node3.content)).tap do |submission|
      submission.submit!(author)
    end
  end
end

Synergy::CMSImport.import_from_all_sections
