# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

topic = Topic.find_or_create_by!(name: "Business")

node1 = GeneralContent.find_or_create_by!({
  name: "Starting a Business",
  section: topic,
  state: :published
})

node2 = node1.children.find_or_create_by!({
  name: "Finding Staff",
  section: topic,
  type: GeneralContent,
  state: :published
})

node2.update_attribute :content_body, 'Lorem ipsum'

node3 = node2.children.find_or_create_by!({
  name: "Types of Employment",
  section: topic,
  type: GeneralContent,
  state: :published
})

password = ENV['SEED_USER_PASSWORD']
raise "SEED_USER_PASSWORD cannot be empty" if password.blank?

if !User.exists?(email: "admin@example.com")
  User.create!(email: "admin@example.com", password: password).add_role :admin
end

if !User.exists?(email: "author@example.com")
  User.create!(email: "author@example.com", password: password).add_role :author, topic.becomes(Section)

end

if !User.exists?(email: "reviewer@example.com")
  User.create!(email: "reviewer@example.com", password: password).add_role :reviewer, topic.becomes(Section)
end
