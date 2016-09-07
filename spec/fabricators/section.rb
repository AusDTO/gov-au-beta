# TODO should not be able to invoke this directly
Fabricator(:section) do
  name { Fabricate.sequence(:section_name) { |i| "section-#{i}" } }
  # TODO why does a section build a root node?
  after_build { Fabricate(:root_node) unless Node.root_node }
end

Fabricator(:agency, from: :section, class_name: :agency) do
  name { Fabricate.sequence(:agency_name) { |i| "agency-#{i}" } }
end

Fabricator(:department, from: :section, class_name: :department) do
  name { Fabricate.sequence(:department_name) { |i| "department-#{i}" } }
end

Fabricator(:topic, from: :section, class_name: :topic) do
  name { Fabricate.sequence(:topic_name) { |i| "topic-#{i}" } }
end

Fabricator(:minister, from: :section, class_name: :minister) do
  name { Fabricate.sequence(:minister_name) { |i| "minister-#{i}" } }
end