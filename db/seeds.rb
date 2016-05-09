# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Topic.delete_all
topic = Topic.create(name: "Business")
# Template.delete_all
# template = Template.create(name: "Main Template")

Node.delete_all
node1 = Node.create(name: "Starting a Business", section: topic, template: "default")
node2 = node1.children.create(name: "Finding Staff", section: topic, template: "default")

ContentBlock.delete_all
content_block = ContentBlock.create(body: "Lorem ipsum", node: node2)