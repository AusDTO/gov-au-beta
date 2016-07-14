Fabricator(:section) do
  transient :with_home
  name { Fabricate.sequence(:section_name) { |i| "section-#{i}" } }
  after_create do |section, transients|
    if transients[:with_home]
      unless Node.root
        Fabricate(:root_node)
      end
      Fabricate(:section_home) do
        section section
        parent Node.root
        name section.name
      end
    end
  end
end

Fabricator(:agency) do
  name { Fabricate.sequence(:agency_name) { |i| "agency-#{i}" } }
end

Fabricator(:department) do
  name { Fabricate.sequence(:department_name) { |i| "department-#{i}" } }
end

Fabricator(:topic) do
  name { Fabricate.sequence(:topic_name) { |i| "topic-#{i}" } }
end
