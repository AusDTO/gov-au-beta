# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'synergy/cms_import'

RootNode.find_or_create_by!(state: 'published')

topic = Topic.find_or_create_by!(name: "Business")
topic.summary = 'The business section covers a range of business-related topics.'
topic.save

news1 = NewsArticle.with_name(
    "Business News"
  ).find_or_create_by!(
    {
      section: topic,
      state: :published,
    }
  ) do |news_article|
    news_article.name = "Business News"
  end
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

node1 = make_node(topic.home_node, "Starting a Business")
node2 = make_node(node1, "Finding Staff")
node2.revise!(content_body: 'lorem ipsum').apply!
node3 = make_node(node2, "Types of Employment")

times = Topic.find_or_create_by!(name: 'Times and dates') do |topic|
  topic.summary = 'Australian times and dates'
end

public_hols = make_node(times.home_node, 'Australian public holidays', CustomTemplateNode)
public_hols.update(template: 'custom/public_holidays_tas')
public_hols_tas = make_node(public_hols, 'Tasmania', CustomTemplateNode)
public_hols_tas.update(template: 'custom/public_holidays_tas')
public_hols_qld = make_node(public_hols, 'Queensland', CustomTemplateNode)
public_hols_qld.update(template: 'custom/public_holidays_qld')
daylight_saving = make_node(times.home_node, 'Australian daylight saving', CustomTemplateNode)
daylight_saving.update(template: 'custom/daylight_savings_tas')
daylight_saving_tas = make_node(daylight_saving, 'Tasmania', CustomTemplateNode)
daylight_saving_tas.update(template: 'custom/daylight_savings_tas')
daylight_saving_qld = make_node(daylight_saving, 'Queensland', CustomTemplateNode)
daylight_saving_qld.update(template: 'custom/daylight_savings_qld')
school_hols = make_node(times.home_node, 'School holidays and term dates', CustomTemplateNode)
school_hols.update(template: 'custom/school_holidays_tas')
school_hols_tas = make_node(school_hols, 'Tasmania', CustomTemplateNode)
school_hols_tas.update(template: 'custom/school_holidays_tas')
school_hols_qld = make_node(school_hols, 'Queensland', CustomTemplateNode)
school_hols_qld.update(template: 'custom/school_holidays_qld')

password = ENV['SEED_USER_PASSWORD']
raise "SEED_USER_PASSWORD cannot be empty" if password.blank?

unless admin = User.find_by(email: "admin@example.com")
  admin = User.create!(email: "admin@example.com", password: password)
end

unless author = User.find_by(email: "author@example.com")
  author = User.create!(email: "author@example.com", password: password)
end

unless reviewer = User.find_by(email: "reviewer@example.com")
  reviewer = User.create!(email: "reviewer@example.com", password: password)
end

unless owner = User.find_by(email: "owner@example.com")
  owner = User.create!(email: "owner@example.com", password: password)
end

admin.add_role :admin
author.add_role :author, topic
reviewer.add_role :reviewer, topic
owner.add_role :owner, topic

node3.content_body = 'This is draft content I would like submitted'

if node3.submissions.blank?
  sub = Submission.new(revision: node3.revise!(node3.content)).tap do |submission|
    submission.submit!(author)
  end
end

names = {
    admin: [admin, %w(Joe Bloggs)],
    author: [author, %w(Jane Doe)],
    reviewer: [reviewer, %w(John Smith)],
    owner: [owner, %w(Sarah Jones)]
}

names.keys.each do |key|
  names[key][0].first_name = names[key][1][0]
  names[key][0].last_name = names[key][1][1]
  names[key][0].save!
end

Synergy::CMSImport.import_from_all_sections
