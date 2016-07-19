# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'synergy/cms_import'

RootNode.create state: 'published'

topic = Topic.find_or_create_by!(name: "Business")
topic.summary = 'The business section covers a range of business-related topics.'
topic.save

node1 = GeneralContent.find_or_create_by!({
  name: "Starting a Business",
  section: topic,
  state: :published,
  parent: topic.home_node
})

node2 = node1.children.find_or_create_by!({
  name: "Finding Staff",
  section: topic,
  type: GeneralContent,
  state: :published
})

node2.revise!(content_body: 'Lorem ipsum').apply!

node3 = node2.children.find_or_create_by!({
  name: "Types of Employment",
  section: topic,
  type: GeneralContent,
  state: :published
})

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
    admin: [admin,  %w(Joe Bloggs)],
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
