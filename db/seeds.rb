# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Topic.where(name: "Business").delete_all
topic = Topic.create(name: "Business")

Node.where(name: "Starting a Business").delete_all
node1 = GeneralContent.create(name: "Starting a Business", section: topic, state: :published)
ContentBlock.where(body: "Lorem ipsum").delete_all
Node.where(name: "Finding Staff").delete_all
node2 = node1.children.create(name: "Finding Staff", section: topic, type: GeneralContent, state: :published)
node2.content_block = ContentBlock.new(body: "Lorem ipsum")
Node.where(name: "Types of Employment").delete_all
node3 = node2.children.create(name: "Types of Employment", section: topic, type: GeneralContent, state: :published)

password = ENV['SEED_USER_ADMIN_PASSWORD']
raise "SEED_USER_ADMIN_PASSWORD cannot be empty" if password.blank?
User.where(email: "admin@example.com").delete_all
User.create! email: "admin@example.com", password: password, is_admin: true
