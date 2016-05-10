Fabricator(:section) do
  name { Fabricate.sequence(:section_name) { |i| "section-#{i}" } }
end